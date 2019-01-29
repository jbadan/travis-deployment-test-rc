#!/usr/bin/env node

var GitHub = require('github-api');

var argv = require('yargs')
    .usage('Usage: $0 [options]')
    .option('tag', {
        alias: 't',
        description: 'Version tag to use for the release',
        type: 'string'
    })
    .option('prerelease', {
        alias: 'p',
        description: 'Use to mark the release as a prerelease',
        type: 'boolean'
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

ghRepo.createRelease({
    'tag_name': argv.tag,
    'target_commitish': 'master',
    'name': `Release ${argv.tag}`,
    'prerelease': argv.prerelease
})
    .then(resp => {
        console.log('\nCreated release', resp.data.id, resp.data.name, '\n\n');
    })
    .catch(e => {
        console.error(e);
    });
