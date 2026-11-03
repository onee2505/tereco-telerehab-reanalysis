
# 03 Explore walking outcomes
# Looks at unusual values, missing follow-up results and how walking
# distance changes over time in each group.

source("R/00_setup.R")


# 3.1 Look more closely at the lowest baseline values
range(dat$mwd1)

dat %>%
  arrange(mwd1) %>%
  select(num_ID, group, mwd1, mwd2, mwd3) %>%
  head(3)

# The 118 m result is low, but later measurements are low too.
# I have kept it rather than removing it just because it is unusual.


# 3.2 Check missing follow-up results by group
table(group = dat$group, missing_6wk = is.na(dat$mwd2))
table(group = dat$group, missing_28wk = is.na(dat$mwd3))
# All seven missing six-week results are in the intervention group.

# Compare starting walking distance for intervention participants with
# and without a six-week result.
dat %>%
  filter(group == "Intervention") %>%
  group_by(missing_6wk = is.na(mwd2)) %>%
  summarise(
    n = n(),
    baseline_6mwd = mean(mwd1)
  )

# Those missing the 6 week assessment walked further at baseline:
# about 561 m, compared with 508 m among those assessed.


# 3.3 Plot walking distance over time
# Put the visit measurements into rows for the summaries and plot.
walk_long <- dat %>%
  select(num_ID, group, mwd1, mwd2, mwd3) %>%
  pivot_longer(mwd1:mwd3, names_to = "visit", values_to = "mwd") %>%
  mutate(
    visit = factor(visit, labels = c("Baseline", "6 weeks", "28 weeks"))
  )

# These means use the available measurements at each visit.
# The number assessed changes over time, so I report n as well.
walk_means <- walk_long %>%
  filter(!is.na(mwd)) %>%
  group_by(group, visit) %>%
  summarise(
    n = n(),
    mean = mean(mwd),
    sd = sd(mwd),
    .groups = "drop"
  )

walk_means
save_table(walk_means, "6mwd_means.csv")

# Faint lines show individual participants; the black line is the group mean.
# The intervention panel is on the left.
p_traj <- ggplot(
  walk_long %>% filter(!is.na(mwd)) %>%
    mutate(group = factor(group, levels = c("Intervention", "Control"))),
  aes(visit, mwd, group = num_ID)
) +
  geom_line(aes(colour = group), alpha = 0.25) +
  stat_summary(aes(group = 1), fun = mean, geom = "line", linewidth = 1.4) +
  facet_wrap(~ group) +
  scale_colour_manual(values = cols, guide = "none") +
  scale_x_discrete(labels = c("Baseline", "6 wk", "28 wk")) +
  labs(x = NULL, y = "6-minute walk distance (m)") +
  theme(strip.text = element_text(size = 16, face = "bold"))

p_traj
save_plot(p_traj, "trajectories.png")


# 3.4 Mean walking distance at each visit
p_means <- ggplot(walk_means, aes(visit, mean, fill = group)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.75) +
  geom_text(aes(label = round(mean)), position = position_dodge(width = 0.8),
            vjust = -0.4, size = 4.5, colour = "grey20") +
  scale_fill_manual(values = cols, name = NULL) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.08))) +
  labs(x = NULL, y = "Mean 6-minute walk distance (m)") +
  theme(panel.grid.major.x = element_blank())

p_means
save_plot(p_means, "mean_6mwd_by_visit.png", w = 8, h = 4.5)


# 3.5 Describe the change from baseline at 6 weeks
dat$change_6wk <- dat$mwd2 - dat$mwd1

tapply(dat$change_6wk, dat$group, mean, na.rm = TRUE)
# Average change is about +17 m in control and +80 m in intervention.
# Both groups improved, so the main analysis compares the groups directly.
