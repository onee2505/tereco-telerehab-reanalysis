
# 04 Compare the groups
# ANCOVA at six weeks and 28 weeks, model checks, and one sensitivity
# check for the missing six-week results.

source("R/00_setup.R")


# 4.1 Estimate the difference at each follow-up
# ANCOVA compares follow-up walking distance while adjusting for baseline.
# Each model uses participants with an observed outcome at that visit.
m6  <- lm(mwd2 ~ group + mwd1, data = dat)
m28 <- lm(mwd3 ~ group + mwd1, data = dat)

summary(m6)
summary(m28)

# Collect the group difference, confidence interval, p-value and sample size.
effect <- function(model, label) {
  ci <- confint(model)["groupIntervention", ]

  data.frame(
    analysis = label,
    estimate = coef(model)[["groupIntervention"]],
    lower = ci[[1]],
    upper = ci[[2]],
    p = summary(model)$coefficients["groupIntervention", 4],
    n = nobs(model)
  )
}

main <- rbind(
  effect(m6, "6 weeks"),
  effect(m28, "28 weeks")
)

main
save_table(main, "main_ancova.csv")
# Adjusted differences: 66.5 m at six weeks (n = 112) and 69.5 m at
# 28 weeks (n = 105). The published estimates were 65.45 m and 68.62 m,
# using a different model.


# 4.2 Check the models
# Residual patterns, unusual observations and the Q-Q plots.
# The plots are also saved so they can be viewed without running R.
for (m in list(list(m6, "diagnostics_6wk.png"),
               list(m28, "diagnostics_28wk.png"))) {
  png(file.path("outputs/figures", m[[2]]),
      width = 9, height = 7, units = "in", res = 150)
  par(mfrow = c(2, 2))
  plot(m[[1]])
  dev.off()
}

# Check whether the relationship between baseline and six-week walking
# distance differs between groups.
anova(m6, lm(mwd2 ~ group * mwd1, data = dat))
# p is about 0.01, suggesting the common-slope model may be too simple.
# I retain this as a model limitation, without making subgroup claims.


# 4.3 Check one assumption about the missing six-week outcomes
# Suppose the seven intervention participants with missing results had
# stayed at their baseline walking distance. Refit the same ANCOVA model
# under that assumption. This scenario does not resolve the missing data.
dat$mwd2_nochange <- ifelse(
  is.na(dat$mwd2),
  dat$mwd1,
  dat$mwd2
)

m6_nochange <- lm(
  mwd2_nochange ~ group + mwd1,
  data = dat
)

sens <- rbind(
  effect(m6, "Main ANCOVA (observed results)"),
  effect(m6_nochange, "Missing six-week results assumed unchanged")
)

sens
save_table(sens, "sensitivity.csv")
# The difference falls from 66.5 m to 59.5 m under this assumption.
# The interval treats the assumed values as fixed; it does not capture
# all uncertainty about the missing outcomes. This check covers six weeks only.


# 4.4 Plot the adjusted differences
# Each point is the extra distance walked by the intervention group,
# with its 95% confidence interval. The dashed line marks no difference.
results <- rbind(
  effect(m6, "6 weeks"),
  effect(m28, "28 weeks"),
  effect(m6_nochange, "6 weeks, missing\nassumed unchanged")
)
results$analysis <- factor(results$analysis, levels = rev(results$analysis))

p_effect <- ggplot(results, aes(estimate, analysis)) +
  geom_vline(xintercept = 0, linetype = "dashed", colour = "grey50") +
  geom_errorbarh(aes(xmin = lower, xmax = upper), height = 0.15,
                 linewidth = 0.8, colour = cols[["Intervention"]]) +
  geom_point(size = 3.5, colour = cols[["Intervention"]]) +
  geom_text(aes(label = sprintf("%.1f m (%.1f to %.1f)", estimate, lower, upper)),
            vjust = -1.2, size = 4.2, colour = "grey20") +
  scale_x_continuous(limits = c(-5, 105)) +
  labs(x = "Adjusted difference in walking distance (m), intervention minus control",
       y = NULL) +
  theme(panel.grid.major.y = element_blank())

p_effect
save_plot(p_effect, "adjusted_differences.png", w = 9, h = 4.5)


# Main findings:
# The intervention group walked further after adjustment for baseline:
# 6 weeks: 66.5 m more than control (95% CI 44.2 to 88.8).
# 28 weeks: 69.5 m more than control (95% CI 43.7 to 95.2).
# In the no-change scenario, the 6 week difference is 59.5 m
# (95% CI 37.6 to 81.3), conditional on the assumed missing values.
