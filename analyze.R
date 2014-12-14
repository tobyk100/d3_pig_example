events <- read.csv(file='events.csv', header=TRUE)
premium_users <- read.csv(file='premium.csv', header=TRUE)

premium_users <- premium_users$user.id
num_unique_users <- length(unique(events$user.id))

use <- events$event == 'provision Blog'
num_blog_users <- length(unique(events[use, 2]))
blog_users <- unique(events[use, 2])
rm(use)

use <- events$event == 'provision eComm'
num_ecomm_users <- length(unique(events[use, 2]))
ecomm_users <- unique(events[use, 2])
rm(use)

blog_and_ecomm_users <- intersect(blog_users, ecomm_users)
num_BandE_users <- length(intersect(blog_users, ecomm_users))

blog_only_users <- setdiff(blog_users, ecomm_users)  # R setdiff is assymetric
ecomm_only_users <- setdiff(ecomm_users, blog_users)  # R setdiff is assymetric

vanilla_users <- setdiff(events$user.id, union(blog_users, ecomm_users))

vanilla_premium_users <- intersect(vanilla_users, premium_users)
blog_premium_users <- intersect(blog_users, premium_users)
ecomm_premium_users <- intersect(ecomm_users, premium_users)
blog_and_ecomm_premium_users <- intersect(blog_and_ecomm_users, premium_users)
