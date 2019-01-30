#!/usr/bin/env node

var GitHub = require('github-api');
var releaseNotes = require('./release-notes');

var argv = require('yargs')
    .usage('Usage: $0 [options]')
    .option('tag', {
        alias: 't',
        description: 'Version tag to use for the release',
        type: 'string'
    })
    .demandOption(['tag'], 'Please provide the version tag to create this release')
    .alias('help', 'h')
    .version(false)
    .help()
    .argv;

var gh = new GitHub({
    token: process.env.GH_TOKEN
});

// even though we have the repo slug (owner_name/repo_name),
// the GitHub API requires them as separate parameters
var repoSlug = process.env.TRAVIS_REPO_SLUG.split('/');

var ghRepo = gh.getRepo(repoSlug[0], repoSlug[1]);

releaseNotes(ghRepo)
    .then(notes => {
        ghRepo.createRelease({
            'tag_name': argv.tag,
            'target_commitish': 'master',
            'name': `Release ${argv.tag}`,
            'body': notes
        })
        .then(resp => {
            console.log('\nCreated release', resp.data.id, resp.data.name, '\n\n');
        })
        .catch(e => {
            console.error(e);
        })
    })
    .catch(e => {
        console.error(e);
    });
