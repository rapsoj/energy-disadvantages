# Set working directory
setwd("~/Desktop")

# Load in libraries
library(ggplot2)
library(ggfittext)
library(extrafont)
library(scales)

# Import fonts
loadfonts()

# Read in data
df <- read.csv("energy.csv")

# Format values as numeric
df$Value <- as.numeric(df$Value)
df$Min <- as.numeric(df$Min)
df$Max <- as.numeric(df$Max)

# Order energy sources
df$Energy.Source <- factor(df$Energy.Source,
                           levels=c("Coal", "Natural Gas", "Biomass",
                                    "Hydropower", "Solar*", "Wind*", "Nuclear"))

# Format titles as equations
df$Metric <- gsub(" ", "~", df$Metric) 
df$Title <- gsub(" ", "~", df$Title) 

# Set facet subtitles
df$Metric.Title <- paste0("atop(bold(", df$Metric, "),(", df$Title, "))")

# Order metrics
df$Metric.Title <- factor(df$Metric.Title,
                    levels=c("atop(bold(Emissions),(Tonnes~per~GWh))",
                             "atop(bold(Danger),(Deaths~per~TWh))",
                             "atop(bold(Land~Use),(m^{2}~per~MWh))",
                             "atop(bold(Materials),(Ton~per~TWh))",
                             "atop(bold(Cost),(Dollars~per~MWh))"))

# Set colours
green <- "#8ea604"
yellow <- "#ec9f05"
blue <- "#487378"
gray <- "#5c6f68"
orange <- "#e34f0e"
red <- "#b83e14"
black <- "#353535"
fill = c(black, red, orange, blue, green, gray, yellow)

# Write caption
cap <- "*Calculations for solar and wind energy assume that they are not supplying baseload power, above scores would be higher if battery storage is also considered\n
Emissions and Danger: Ritchie, H. (2020). What are the safest and cleanest sources of energy? Our World in Data.
Land Use: United Nations Convention to Combat Desertification. (2017). Energy and Land Use (pg. 8).
Materials: Quadrennial Technology Review. (2017). An Assessment of Energy Technologies and Reseach Opportunities (pg. 390).
Cost: U.S. Energy Information Administration. (2021). Levelized Costs of New Generation Resources in the Annual Energy Outlook 2021 (pg. 11)."

# Build visualization
ggplot(df, aes(x=Energy.Source, y=Value,
               label = format(..y.., big.mark = ","))) +
  geom_bar(stat = "identity", fill = rep(fill, times = 5)) +
  geom_bar_text(size = 14, grow = FALSE, family = "CMU Bright") +
  labs(title = "Which Energy Source has the Least Disadvantages?",
       subtitle = "Comparing common concerns for seven energy sources",
       caption = cap) +
  xlab("") +
  ylab("") +
  facet_grid(.~Metric.Title, scales="free", labeller = label_parsed) +
  theme_gray() +
  coord_flip() +
  theme(text=element_text(size=12, family = "CMU Bright"),
        strip.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16),
        title = element_text(size = 20),
        plot.caption = element_text(size = 8, hjust = 0, vjust = 0),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank())

