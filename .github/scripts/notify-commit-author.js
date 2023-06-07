#!/usr/bin/env node

const commentSignature = '<!-- notify-commit-author.js -->';

module.exports = async ({github, context, commits}) => {
    // Create message
    const messageHeader = `${commentSignature}\n@${context.actor}, please consider cherry-picking these commits into 'origin/main':\n`;
    const message = commits
        .split(' ')
        .reduce((str, commit) => `${str}${commit}\n`, messageHeader);

    // Get the latest comment, if any
    const {data: comments} = await github.rest.issues.listComments({
        owner: context.repo.owner,
        repo: context.repo.repo,
        issue_number: context.issue.number,
    });
    const comment = comments.find(c => c.body.includes(commentSignature));

    // Delete comment if it exists
    if (comment) {
        await github.rest.issues.deleteComment({
            owner: context.repo.owner,
            repo: context.repo.repo,
            comment_id: comment.id,
        });
    }

    // Create comment if there is something to comment on
    if (message !== '') {
        await github.rest.issues.createComment({
            owner: context.repo.owner,
            repo: context.repo.repo,
            issue_number: context.issue.number,
            body: message,
        });
    }
}
