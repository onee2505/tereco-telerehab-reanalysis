
# 01 Check the data
# Confirms the size of the dataset, checks IDs and plausible values,
# counts missing walk tests and builds the baseline table.

source("R/00_setup.R")


# 1.1 Check the structure
dim(dat)        # 119 participants and 83 original variables (+2 labels)
names(dat)
glimpse(dat)


# 1.2 Check IDs and plausible values
n_distinct(dat$num_ID) == nrow(dat) # TRUE means each participant appears once

summary(dat[, c("age", "mwd1", "mwd2", "mwd3")])
# Baseline walking distance ranges from 118 to 732 m.
# Participants are approximately 21 to 74 years old.


# 1.3 Count missing walking measurements
colSums(is.na(dat[, c("mwd1", "mwd2", "mwd3")]))
# No missing baseline results; seven at six weeks and 14 at 28 weeks.


# 1.4 Count participants by group
table(dat$group) # 60 control and 59 intervention participants
table(dat$group, dat$sex)


# 1.5 Summarise the groups at baseline
# Age and walking distance are shown as mean (SD); males as number (%).
# This is a descriptive table, without baseline significance tests.
baseline <- dat %>%
  group_by(group) %>%
  summarise(
    n = n(),
    age = sprintf("%.1f (%.1f)", mean(age), sd(age)),
    male = sprintf("%d (%.0f%%)", sum(sex == "Male"), 100 * mean(sex == "Male")),
    mwd_baseline = sprintf("%.1f (%.1f)", mean(mwd1), sd(mwd1))
  )

baseline
save_table(baseline, "baseline_by_group.csv")
