
if(!require(readxl)) {install.packages("readxl"); library(readxl)}
if(!require(ggplot2)) {install.packages("ggplot2"); library(ggplot2)}


dataClasses <- c("text", "text", "numeric", "text")


if(!file.exists("sidekicks/gamedata.xlsx")) {
    dataURL <- "https://drive.google.com/uc?export=download&id=0Bzru6kclmhCGTEtZdzVxVzNyUDQ"
    download.file(dataURL, "sidekicks/gamedata.xlsx", mode = "wb")}
gameData <- read_excel("sidekicks/gamedata.xlsx", col_types = dataClasses)

gameData$Platform <- as.factor(gameData$Platform)


keepPlatforms <- c("GameCube", "Nintendo 64", "PC", "PlayStation",
                   "PlayStation 2", "PlayStation 3", "PlayStation 4", "Wii",
                   "Wii U", "Xbox", "Xbox 360", "Xbox One")

gameData <- subset(gameData, gameData$Platform %in% keepPlatforms)
gameData$Platform <- factor(gameData$Platform)

platColors <- c("GameCube" = "#9966FF",
                "Nintendo 64" = "#CC0000",
                "PC" = "#F4E004",
                "PlayStation" = "#7486fc",
                "PlayStation 2" = "#3d54e5",
                "PlayStation 3" = "#0224ff",
                "PlayStation 4" = "#061caa",
                "Wii" = "#4cf9ff",
                "Wii U" = "#07aaaf",
                "Xbox" = "#80FF80",
                "Xbox 360" = "#00E600",
                "Xbox One" = "#006600")

gameData$MainGenre <- gsub(",.*", "", gameData$Genre)
gameData$MainGenre <- as.factor(gameData$MainGenre)

genreChoices <- as.character(levels(gameData$MainGenre))
genreColors <- c("dodgerblue2", "#E31A1C", "green4", "#6A3D9A", "#FF7F00",
                 "black", "gold1", "skyblue2", "#FB9A99", "palegreen2", "#CAB2D6",
                 "#FDBF6F", "gray70", "khaki2", "maroon", "orchid1", "deeppink1",
                 "blue1", "steelblue4", "darkturquoise", "green1", "yellow4",
                 "yellow3", "darkorange4", "brown", "tomato", "darkblue", "green",
                 "salmon3", "seagreen")
names(genreColors) <- genreChoices
