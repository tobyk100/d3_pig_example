events <- read.csv(file='events.csv', header=TRUE)
premium_users <- read.csv(file='premium.csv', header=TRUE)

premium_users <- premium_users$user.id

use <- events$event == 'provision Blog'
blog_users <- unique(events[use, 2])
rm(use)

use <- events$event == 'provision eComm'
ecomm_users <- unique(events[use, 2])
rm(use)

blog_only_users <- setdiff(blog_users, ecomm_users)  # R setdiff is assymetric
ecomm_only_users <- setdiff(ecomm_users, blog_users)  # R setdiff is assymetric
blog_and_ecomm_users <- intersect(blog_users, ecomm_users)
vanilla_users <- setdiff(events$user.id, union(blog_users, ecomm_users))

blog_premium_users <- intersect(blog_users, premium_users)
ecomm_premium_users <- intersect(ecomm_users, premium_users)
blog_and_ecomm_premium_users <- intersect(blog_and_ecomm_users, premium_users)
vanilla_premium_users <- intersect(vanilla_users, premium_users)

blog_only_conversion_rate = length(blog_premium_users) / length(blog_only_users)
ecomm_only_conversion_rate = length(ecomm_premium_users) / length(ecomm_only_users)
blog_and_ecomm_conversion_rate = length(blog_and_ecomm_premium_users) / length(blog_and_ecomm_users)
vanilla_conversion_rate = length(vanilla_premium_users) / length(vanilla_users)

barplot(c(blog_only_conversion_rate, ecomm_only_conversion_rate))
