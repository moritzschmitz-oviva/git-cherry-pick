#!/usr/bin/env node

module.exports = async ({github, context}) => {
    await github.rest.repos.updateBranchProtection({
        owner: context.repo.owner,
        repo: context.repo.repo,
        branch: 'main',
    })
    console.log(github, context);
}
