zerv flow --bumped-branch develop --branch-rules '[(pattern:"develop",pre_release_label:beta,pre_release_num:Some(1),post_mode:commit),(pattern:"release/*",pre_release_label:rc,pre_release_num:None,post_mode:tag)]'

zerv flow --bumped-branch develop --branch-rules '[(pattern:"develop",pre_release_label:beta,pre_release_num:Some(1),post_mode:commit),(pattern:"release/*",pre_release_label:rc,post_mode:tag)]'

zerv flow --branch-rules '[(pattern:"develop",pre_release_label:beta,pre_release_num:Some(1),post_mode:commit),(pattern:"release/*",pre_release_label:rc,post_mode:tag)]'

zerv flow --schema standard-base-prerelease-post-dev-context --branch-rules '[
(
pattern: "develop",
pre_release_label: beta,
pre_release_num: Some(1),
post_mode: commit
),
(
pattern: "release/*",
pre_release_label: rc,
pre_release_num: None,
post_mode: tag
),
(
pattern: "*",
pre_release_label: alpha,
pre_release_num: None,
post_mode: commit
)
]'

zerv flow --branch-rules '
[
(
pattern: "develop",
pre_release_label: beta,
pre_release_num: Some(1),
post_mode: commit
),
(
pattern: "release/*",
pre_release_label: rc,
pre_release_num:None, p
ost_mode: tag
)
]'

zerv flow --bumped-branch release/15/dev --bumped-commit-hash g55379b521242466a4d9acfccf11ecd5480430d95 --branch-rules '[ ( pattern: "develop", pre_release_label: beta, pre_release_num: Some(1), post_mode: commit ), ( pattern: "release/*", pre_release_label: rc, pre_release_num: None, post_mode: tag ), ( pattern: "*", pre_release_label: alpha, pre_release_num: None, post_mode: commit ) ] ' --output-format zerv
