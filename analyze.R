events <- read.csv(file='events.csv', header=TRUE)
premium_users <- read.csv(file='premium.csv', header=TRUE)
premium_users <- premium_users$user.id

filter_events_by_type <- function(type, column = 2, unique = T) {
  is_event_type <- events$event == type
  filtered_events = events[is_event_type, column]
  if(unique) {
    return(unique(filtered_events))
  }

  return(filtered_events)
}

users_with_failure = filter_events_by_type('save Failure')

user_stats <- function(users) {
  premium_users = intersect(users, premium_users)
  conversion_rate = 100.0 * length(premium_users) / length(users)
  blog_only_users_with_failure = intersect(users_with_failure, blog_only_users)
  failed = intersect(users, users_with_failure)
  failure_rate = 100.0 * length(failed) / length(users)
  stats = list(users = users,
               premium_users = premium_users,
               conversion_rate = conversion_rate,
               failed = failed,
               failure_rate = failure_rate)
  return(stats)
}

blog_users = filter_events_by_type('provision Blog')
ecomm_users = filter_events_by_type('provision eComm')

blog_only_users <- setdiff(blog_users, ecomm_users)  # R setdiff is assymetric
ecomm_only_users <- setdiff(ecomm_users, blog_users)  # R setdiff is assymetric
blog_and_ecomm_users <- intersect(blog_users, ecomm_users)
vanilla_users <- setdiff(events$user.id, union(blog_users, ecomm_users))

blog_only_stats = user_stats(blog_only_users)
ecomm_only_stats = user_stats(ecomm_only_users)
blog_and_ecomm_stats = user_stats(blog_and_ecomm_users)
vanilla_stats = user_stats(vanilla_users)

visual <- F
# Conversion Rates
if (visual) {
  barplot(t(c(blog_only_stats$conversion_rate,
              ecomm_only_stats$conversion_rate,
              blog_and_ecomm_stats$conversion_rate,
              vanilla_stats$conversion_rate)),
          names = c("Blog Only",
                    "Ecomm Only",
                    "Blog and Ecomm",
                    "Vanilla"),
          main = "Conversion Rate by User Type",
          ylab = "Conversion Rate %",
          xlab = "User Type")
  dev.new()
  premium_user_failure_rate = length(intersect(users_with_failure, premium_users)) / length(premium_users)  # 0.0
  barplot(t(c(blog_only_stats$failure_rate,
              ecomm_only_stats$failure_rate,
              blog_and_ecomm_stats$failure_rate,
              vanilla_stats$failure_rate,
              premium_user_failure_rate)),
          names = c("Blog Only",
                    "Ecomm Only",
                    "Blog and Ecomm",
                    "Vanilla",
                    "Premium"),
          main = "Failure Rate by User Type",
          ylab = "Failure Rate %",
          xlab = "User Type")
}

#Get the timestamps for failures. Currently missing sub-second values
use <- events$event == 'save Failure'
failures = filter_events_by_type('save Failure', column = 1, unique = F)
failure_times <- strptime(failures, format="%Y-%d-%mT%H:%M:%S")
bins_by_hour <- cut(failure_times,
                    breaks=seq(as.POSIXct('2013-04-09 13:00:00'),
                               by='1 hour',
                               length=10))
