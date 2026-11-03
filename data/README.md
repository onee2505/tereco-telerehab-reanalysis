# TERECO public dataset

## Source

| | |
|---|---|
| **File** | `TERECO_Public_Data_wide.csv` |
| **Trial** | TERECO: Telerehabilitation programme in post-discharge COVID-19 patients |
| **Original paper** | Li J, et al. *Thorax*. 2022;77:697–706 |
| **Downloaded from** | Dryad, doi: [10.5061/dryad.59zw3r27n](https://doi.org/10.5061/dryad.59zw3r27n) |
| **Size** | 119 rows (participants) × 83 columns (variables) |
| **Layout** | Wide: one row per participant. Measures taken at several visits have a number at the end: `1` = baseline, `2` = 6 weeks, `3` = 28 weeks |
| **Dataset page** | <https://datadryad.org/dataset/doi:10.5061/dryad.59zw3r27n> |
| **Licence** | CC0 1.0 (public domain) |
| **Published on Dryad** | July 2021 |

The file is included here unchanged. Please cite the original trial and the Dryad
record if you use it.

## How to download it

1. Open the dataset page: <https://datadryad.org/dataset/doi:10.5061/dryad.59zw3r27n>
2. Under *Files*, click **`TERECO_Public_Data_wide.csv`** to download it.
3. Save it in this `data/` folder with the same name.

The same page also has the codebook (`CodebookTERECO_Public.pdf`), which explains
the coding of every column, and a Stata version of the data (`.dta`).

## Columns used in this analysis

| Column | Meaning | Values |
|---|---|---|
| `num_ID` | Participant ID | 1 to 119, one row each |
| `center` | Study hospital | 1, 2, 3 |
| `group_randomized` | Randomised group | 1 = Intervention, 2 = Control |
| `male` | Sex | 1 = Male, 0 = Female |
| `age` | Age in years | about 21 to 74 |
| `_6MWD1` | 6-minute walk distance at baseline (m) | 118 to 732, no missing |
| `_6MWD2` | 6-minute walk distance at 6 weeks (m) | 7 missing |
| `_6MWD3` | 6-minute walk distance at 28 weeks (m) | 14 missing |
| `com2_hypertension`, `com2_diabetes`, `com2_obesity`, `com2_heartdisease`, `com2_lungdisease`, `com2_other` | Has this condition | 1 = Yes, 0 = No |

In the R scripts, `_6MWD1`, `_6MWD2` and `_6MWD3` are renamed to `mwd1`, `mwd2`
and `mwd3`.

## All columns, grouped

| Group | Columns |
|---|---|
| **IDs and design** | `num_ID`, `center`, `group_randomized`, `pp_sample` (per-protocol sample) |
| **Demographics** | `male`, `age`, `smoke_history` |
| **Hospital stay** | `days_onset_to_admission`, `disease_sev_bin`, `treat_corticosteroid`, `treat_oxygen`, `los_days` (length of stay) |
| **Health conditions** | `comorbidity_cat`, `com2_diabetes`, `com2_heartdisease`, `com2_lungdisease`, `com2_obesity`, `com2_hypertension`, `com2_other` |
| **Timing** | `days_discharge_bl`, `days_base_post`, `days_base_fu`, `time_onset1`–`3`, `time_onset_2w`, `time_onset_4w` |
| **Walking capacity** | `_6MWD1`–`3` |
| **Leg strength** | `squat1`–`3` (squat time) |
| **Lung function** | `fvc`, `fev`, `fev_fvc_ratio`, `mvv`, `pef` (each 1–3), plus percent-predicted versions (`*_GLIpercpred*`, `*_cn_percpred*`), predicted values and below-normal flags |
| **Quality of life** | `SF12_PCS1`–`3` (physical), `SF12_MCS1`–`3` (mental) |
| **Breathlessness** | `mMRC1`, `mMRC_fav1`–`3`, `mMRC_fav2w`, `mMRC_fav4w` |

For the exact coding of every column, see the codebook on the Dryad record.

## Quick counts

| | Control | Intervention | Total |
|---|---|---|---|
| Participants | 60 | 59 | 119 |
| Female / Male | 34 / 26 | 32 / 27 | 66 / 53 |
| Centre 1 / 2 / 3 | 2 / 26 / 32 | 3 / 23 / 33 | 5 / 49 / 65 |
| Walk test at baseline | 60 | 59 | 119 |
| Walk test at 6 weeks | 60 | 52 | 112 |
| Walk test at 28 weeks | 55 | 50 | 105 |
