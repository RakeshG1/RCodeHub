# Import Libraries #
# ---------------- #
pacman::p_load(ggplo2,            # visualization package
               ggpubr,            # Easy creation of publication-ready plots and tables using ggplot2
               data.table,        # Extension of data.frame, optimized for fast data manipulation and handling large datasets
               dplyr,             # Data manipulation, making data wrangling tasks easier
               tidyverse,         # Tools for data manipulation, visualization, and analysis
               timetk,            # Cleaning, manipulating, and visualizing time-based data
               lubridate,         # Intuitive functions for date-time manipulation
               shiny,             # To build interactive web applications
               shinycssloaders,   # Customizable CSS-based loaders for Shiny applications
               shinythemes,       # Additional themes for Shiny applications
               scales             # Informative visualizations, including transformations, breaks, and labels for axes and legends
               )

# Set Working Directory
setwd("C:/Users/rakes/Local/Git_Repo/RCodeHub/EDA")

# Data Import #
# ----------- #
file_path <- paste(getwd(), "/Data/tennis.csv", sep="")
df_sample_data <- read.csv(file = file_path, header = TRUE)

# Data Preparation #
# ---------------- #

# Type conversion : Creates POSIXct datatype
df_sample_data <- df_sample_data %>%
                  mutate(datetime_24hr_format = as.POSIXct(as.character(datetime_24hr_format), format = "%d-%m-%Y %H:%M:%S")) %>%
                  mutate(datetime_12hr_format = as.POSIXct(as.character(datetime_12hr_format), format = "%d-%m-%Y %H:%M:%S"))

# Create date column
df_sample_data <- df_sample_data %>% mutate(Date = ymd(lubridate::date(datetime_24hr_format)))

# Data Overview
typeof(df_sample_data)
str(df_sample_data)
dim(df_sample_data)
df_sample_data %>% head(2) %>% print()
df_sample_data %>% tail(2) %>% print()

# Aggregate : Min & Max Date
df_sample_data %>% summarise(min = min(Date),
                             max = max(Date))
print(paste("Min Date:", min(df_sample_data$Date, na.rm=TRUE), " --> Max Date:", max(df_sample_data$Date, na.rm = TRUE)))

# Data Copy
df_temp <- data.table::copy(df_sample_data)
df_temp <- df_temp %>% filter((play %in% c("yes")))


# EDA #
# --- #

df_sample_data %>% count(outlook, sort=TRUE)

table(df_sample_data$outlook)

# Pivot table
table(df_sample_data$outlook, df_sample_data$humidity)

df_sample_data %>% ggplot(aes(x = outlook)) +
                   geom_bar() +
                   geom_text(stat = "count", aes(label = after_stat(count)), vjust = 0, colour="orange") +
                   ggtitle("Outlook Analysis")

df_sample_data %>% ggplot(aes(x = play)) + 
                   geom_bar() +
                   facet_wrap(~outlook, scales = "free_x") + 
                   ggtitle("Outlook vs Play Overview")

df_sample_data %>% ggplot(aes(x = play)) +
                   geom_bar() +
                   coord_flip() +
                   facet_wrap(~outlook, scales = "free_x") + 
                   ggtitle("Outlook vs Play Overview")

df_sample_data %>% ggplot(aes(x = index, y = temperature)) +
                   geom_point(colour="darkgreen", alpha = 0.6) + 
                   # geom_jitter(alpha = 0.3, color = "tomato")
                   facet_grid(~outlook+humidity, scales = "free_y") +
                   ggtitle("Outlook, Humidity vs Play Overview")

df_sample_data %>% ggplot(aes(x = index, y = temperature)) + 
                    geom_line(colour = "orange") + 
                    geom_point(colour="darkgreen", alpha = 0.6) +
                    facet_grid(outlook ~ humidity, scales = "free_x") +
                    ggtitle("Outlook, Humidity vs Play Overview")

df_sample_data %>% ggplot(aes(x = index, y = temperature)) +
                    geom_area(fill = "steelblue", colour="black") +
                    facet_grid(outlook ~ humidity, scales = "free_x") +
                    theme(axis.text.x = element_text(angle = 0, vjust = 0.5, hjust = 1)) + 
                    ggtitle("Outlook, Humidity vs Play Overview")

df_sample_data %>% ggplot(aes(x = index, y = temperature)) +
                    geom_point(aes(shape=play, colour=play, size = 3)) + 
                    ggtitle("Temperature Overview") +
                    theme(legend.position="top")
























