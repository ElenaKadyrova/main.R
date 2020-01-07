library(httr)
library(jsonlite)
library(ggplot2)
library(plotly)
library("lintr")

Data <- function() { 
  json <- fromJSON('https://apidata.mos.ru/v1/datasets/2072/rows?api_key=19bf8a42ae21086d117f5d8460ad0457')
  return(json)
}

df <- Data()
df$Number <-NULL 
df$global_id <- NULL
df$Cells$global_id <- NULL 
df$Cells$District <- NULL 
df$Cells$EDU_NAME <- NULL
print(df)

plotBar <- function() {
  plot_ly(df, x = df$Cells$YEAR, y = df$Cells$PASSER_UNDER_160, type = 'bar', 
          name = 'Получившие менее 160 баллов') %>%
    add_trace(y = df$Cells$PASSES_OVER_220, 
          name = 'Получившие более 220 баллов') %>%
    layout(title = 'Распределение групп учащихся по годам', 
          yaxis = list(title = 'Количество учащихся'), barmode = 'group')
}

plotBar2 <- function() {
  plot_ly(df, x = df$Cells$AdmArea, y = df$Cells$PASSER_UNDER_160, type = 'bar', 
          name = 'Получившие менее 160 баллов') %>%
    add_trace(y = df$Cells$PASSES_OVER_220, 
          name = 'Получившие более 220 баллов') %>%
    layout(title = 'Группы учащихся по округам за период 2016-2019 гг', 
          yaxis = list(title = 'Количество учащихся'), barmode = 'stack')
}

plotScatter <- function() {
  colnames(df$Cells)[2] <- 'Период сдачи экзаменов'
  ggplot(df$Cells, aes(df$Cells$PASSER_UNDER_160, df$Cells$PASSES_OVER_220, colour = `Период сдачи экзаменов`)) + 
    geom_point() +
    scale_x_discrete(name = 'Количество учащихся, сдавших экзамены на менее, чем 160 баллов') +
    scale_y_discrete(name = 'Количество учащихся, сдавших экзамены на более, чем 220 баллов') +
    labs(title = 'Соотношение баллов экзамена по годам')
}

df <- Data()
plotBar()
plotBar2()
plotScatter()

lintr::lint("main.R")