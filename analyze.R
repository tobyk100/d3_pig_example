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

timestamp_format <- "%Y-%d-%mT%H:%M:%S"
#Get the timestamps for save start events
use <- events$event == 'save start'
start_times <- strptime(events[use, 1], format=timestamp_format)

#Get the timestamps for failures. Currently missing sub-second values
use <- events$event == 'save Failure'
failure_times <- strptime(events[use, 1], format=timestamp_format)
bins_by_hour <- cut(failure_times,
                    breaks=seq(from=min(failure_times),
                               to=max(failure_times),
                               by='1 hour'))

bins_by_quarter_hour <- cut(failure_times,
                            breaks=seq(from=min(failure_times),
                               to=max(failure_times),
                               by=as.difftime(c("15"), format="%M")))

#define the layout properties for the plots
two_plot_layout <- function(){
    layout(matrix(data=c(1,2), nrow=1, ncol=2))
}

show_trend_by_hours <- function(h=1){
    tdiff <- as.difftime(c(h), units="hours")
    show_trend(tdiff)
    
}

show_trend_by_minutes <- function(m=15){
    tdiff <- as.difftime(c(m), units="mins")
    show_trend(tdiff)
}

show_trend <- function(tdiff){
    interval_breaks <- seq(from=min(start_times),
                           to=max(start_times),
                           by=tdiff)
    fbins <- cut(failure_times, breaks=interval_breaks)
    total_bins <- cut(start_times, breaks=interval_breaks)
    two_plot_layout()
    barplot(table(fbins),
            main=paste(c("Number of failures every", paste(tdiff, units(tdiff)))))
    barplot(table(fbins) / table(total_bins),
            main=paste(c("Proportion of failures every", paste(tdiff, units(tdiff)))))
}


