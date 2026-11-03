
# 02 Dataset overview
# Bar charts that show how many participants fall into each category,
# split by randomised group. These give a quick picture of the dataset
# before any analysis.

source("R/00_setup.R")


# One bar chart style for all counts:
# bars side by side for each group, with the count printed above each bar.
count_bars <- function(d, x, xlab = NULL) {
  ggplot(d, aes({{ x }}, n, fill = group)) +
    geom_col(position = position_dodge(width = 0.8), width = 0.75) +
    geom_text(aes(label = n), position = position_dodge(width = 0.8),
              vjust = -0.4, size = 4.5, colour = "grey20") +
    scale_fill_manual(values = cols, name = NULL) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
    labs(x = xlab, y = "Participants") +
    theme(panel.grid.major.x = element_blank())
}


# 2.1 Participants in each group
by_group <- dat %>% count(group)
by_group

p_group <- count_bars(by_group, group) +
  theme(legend.position = "none")

p_group
save_plot(p_group, "overview_group.png", w = 6, h = 4.5)


# 2.2 Sex by group
by_sex <- dat %>% count(sex, group)
by_sex

p_sex <- count_bars(by_sex, sex)
p_sex
save_plot(p_sex, "overview_sex.png", w = 7, h = 4.5)


# 2.3 Age band by group
by_age <- dat %>%
  mutate(age_band = cut(age, breaks = c(20, 30, 40, 50, 60, 70, 80),
                        labels = c("20-29", "30-39", "40-49",
                                   "50-59", "60-69", "70+"),
                        right = FALSE)) %>%
  count(age_band, group)
by_age

p_age <- count_bars(by_age, age_band, xlab = "Age (years)")
p_age
save_plot(p_age, "overview_age.png", w = 9, h = 4.5)


# 2.4 Study centre by group
# The public file codes the three hospitals as 1, 2 and 3.
by_centre <- dat %>%
  mutate(centre = factor(center, labels = paste("Centre", 1:3))) %>%
  count(centre, group)
by_centre

p_centre <- count_bars(by_centre, centre)
p_centre
save_plot(p_centre, "overview_centre.png", w = 7, h = 4.5)


# 2.5 Comorbidities by group
# One participant can have more than one condition.
by_comorb <- dat %>%
  select(group, starts_with("com2_")) %>%
  pivot_longer(-group, names_to = "condition", values_to = "has") %>%
  group_by(condition, group) %>%
  summarise(n = sum(has == 1, na.rm = TRUE), .groups = "drop") %>%
  mutate(condition = recode(condition,
                            com2_hypertension = "Hypertension",
                            com2_diabetes = "Diabetes",
                            com2_obesity = "Obesity",
                            com2_heartdisease = "Heart disease",
                            com2_lungdisease = "Lung disease",
                            com2_other = "Other"),
         condition = reorder(condition, n, sum))
by_comorb

p_comorb <- ggplot(by_comorb, aes(n, condition, fill = group)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.75) +
  geom_text(aes(label = n), position = position_dodge(width = 0.8),
            hjust = -0.3, size = 4.5, colour = "grey20") +
  scale_fill_manual(values = cols, name = NULL) +
  scale_x_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(x = "Participants", y = NULL) +
  theme(panel.grid.major.y = element_blank())

p_comorb
save_plot(p_comorb, "overview_comorbidities.png", w = 9, h = 5)


# 2.6 Walk tests completed at each visit
# This shows where follow-up results are missing.
by_visit <- dat %>%
  select(group, mwd1, mwd2, mwd3) %>%
  pivot_longer(-group, names_to = "visit", values_to = "mwd") %>%
  filter(!is.na(mwd)) %>%
  mutate(visit = factor(visit, labels = c("Baseline", "6 weeks", "28 weeks"))) %>%
  count(visit, group)
by_visit
save_table(by_visit, "walk_tests_completed.csv")

p_visit <- count_bars(by_visit, visit)
p_visit
save_plot(p_visit, "overview_walk_tests_completed.png", w = 8, h = 4.5)
