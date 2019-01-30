const buildCommitMessage = (commit, pullRequests, breaking) => {
    var template = (msg, sha, url, prNumber, prUrl) =>
        `${msg}${prNumber ? ` ([#${prNumber}](${prUrl}))` : ''} ([${sha}](${url}))`;

    var message = commit.message;
    var delimiter = (breaking ? 'BREAKING CHANGE:' : ':');
    var pos = message.indexOf(delimiter);
    if (pos !== -1) {
        message = message.substring(pos + delimiter.length).trim();
    }

    // if it's not a breaking commit message, let's trim off anything after the new lines
    // or the (#00) PR number, if there is one
    if (!breaking) {
        pos = message.indexOf(commit.prNumber ? '(#' : '\n\n');
        if (pos !== -1) {
            message = message.substring(0, pos).trim();
        }

        return template(message, commit.sha.substring(0, 7), commit.url, commit.prNumber, pullRequests[`pr_${commit.prNumber}`]);
    }

    return template(message, commit.sha.substring(0, 7), commit.url);
};

const buildMessages = (commits, pullRequests) => {
    var messages = {
        breaking: [],
        features: [],
        fixes: []
    };

    commits.forEach(commit => {
        if (commit.message.match(/BREAKING CHANGE\:/)) {
            messages.breaking.push(buildCommitMessage(commit, pullRequests, true));
        }

        if (commit.message.match(/^fix/)) {
            messages.fixes.push(buildCommitMessage(commit, pullRequests));
        }

        if (commit.message.match(/^feat/)) {
            messages.features.push(buildCommitMessage(commit, pullRequests));
        }
    });

    return messages;
};

const buildReleaseNotes = (messages) => {
    var notes = [];

    if (messages.breaking.length > 0) {
        notes.push('\n### BREAKING CHANGES\n');
        notes = notes.concat(messages.breaking.map(msg => `* ${msg}`));
    }

    if (messages.features.length > 0) {
        notes.push('\n### Features\n');
        notes = notes.concat(messages.features.map(msg => `* ${msg}`));
    }

    if (messages.fixes.length > 0) {
        notes.push('\n### Bug Fixes\n');
        notes = notes.concat(messages.fixes.map(msg => `* ${msg}`));
    }

    return notes.join('\n');
};

const getCommits = (ghRepo) =>
    ghRepo.listCommits()
        .then(resp => {
            var commits = (!Array.isArray(resp.data) ? [resp.data] : resp.data);
            var filteredCommits = [];

            for (var i = 0; i < commits.length; i++) {
                var message = commits[i].commit.message;

                // continue until the first non-rc version is found
                if (message.match(/^chore\(release\):\sversion\s[0-9]+\.[0-9]+\.[0-9]+\s/)) {
                    break;
                }

                // skip over system-generated commits
                if (message.match(/\[ci skip\]$/)) {
                    continue;
                }

                var prMatch = message.match(/\(\#\d+\)/);
                if (prMatch) {
                    prMatch = prMatch[0].match(/\d+/);
                }

                filteredCommits.push({
                    sha: commits[i].sha,
                    url: commits[i].html_url,
                    message: commits[i].commit.message,
                    prNumber: (prMatch ? parseInt(prMatch[0], 10) : null)
                });
            }

            return filteredCommits;
        })
        .catch(e => {
            console.error(e);
        });

const getPullRequest = (ghRepo, prNumber) =>
    ghRepo.getPullRequest(prNumber)
        .then(resp => {
            return { [`pr_${resp.data.number}`]: resp.data.html_url };
        })
        .catch(e => {
            console.error(e);
        });

module.exports = (ghRepo) =>
    getCommits(ghRepo)
        .then(commits => {
            return Promise.all(commits.filter(commit => !!commit.prNumber).map(commit =>
                getPullRequest(ghRepo, commit.prNumber)
            ))
            .then(pullRequests => {
                pullRequestLookup = {};
                pullRequests.forEach(pullRequest => {
                    Object.assign(pullRequestLookup, pullRequest);
                })
                return buildReleaseNotes(buildMessages(commits, pullRequestLookup));
            })
        })
        .catch(e => {
            console.error(e);
        });
