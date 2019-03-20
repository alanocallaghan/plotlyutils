## ------------------------------------------------------------------------
# Load packages and prepare data
suppressPackageStartupMessages({
  library("rtweet")
  library("dplyr")
  library("tidytext")
  library("httr")
  library("stringr")
  library("purrr")
  library("RColorBrewer")
  library("scales")
  library("tidyr")
  library("igraph")
  # library("plotlyutils")
  library("htmlwidgets")
  library("networkD3")
  library("here")
  library("datasauRus")
  library("plotly")
  library("devtools")  
})
suppressMessages(suppressPackageStartupMessages(load_all(here())))

# See [Elliot Meador's talk](https://github.com/EdinbR/edinbr-talks/blob/master/2019-01-16/ElliotMeador_EdinR_stripped.html) for information on the 
# specifics. 
# Sincere thanks for sharing the code for this analysis.
if (!file.exists(here("data/graph_data.rds")) || 
    !file.exists(here("data/tweet_g.rds"))) {
  create_token(
    app = 'network_tweets',
    consumer_key = Sys.getenv("consumer_key"),
    consumer_secret = Sys.getenv("consumer_secret")
    # ,
    # access_token = Sys.getenv("access_token"),
    # access_secret = Sys.getenv("access_secret")
  )
  ntweets <- 20

  alfa <- get_timeline(Sys.getenv("twitter_handle"), n = ntweets) # user handle in the quotes
  regex <- "@([A-Za-z]+[A-Za-z0-9_]+)(?![A-Za-z0-9_]*\\.)"
  replace_reg1 <- 'https://t.co/[A-Za-z\\d]+|'
  replace_reg2 <- 'http://[A-Za-z\\d]+|&amp;|&lt;|&gt|RT|https'
  replace_reg <- paste0(replace_reg1, replace_reg2)
  unnest_reg <-  "([^A-Za-z\\d#@']|'(?![A-Za-z_\\d#@]))"


  mentions <- alfa %>% 
    filter(!grepl('^RT', text)) %>%
    mutate(text = gsub(replace_reg, '', text),
      row.id = row_number()) %>%
    unnest_tokens(word,
      text,
      token = 'regex',
      pattern = unnest_reg,
      collapse = FALSE) %>%
    mutate(mentioned = ifelse(grepl('@', word), word, NA)) %>%
    distinct(mentioned) %>%
    na.omit() %>%
    pull(mentioned)

  foxtrot <- map_df(mentions, function(x) { #map_df merges the dataframes
    get_timeline(x, n = ntweets)
  })
  
  golf <- foxtrot %>%
    mutate_if(is.list, simplify_all) %>%   # take all lists and simplify
    as_tibble()  %>%
    mutate_if(is.list, as.character) %>%   # change all lists to a character
    filter(!str_detect(text  , '^RT')) %>% # this is the same as above
    mutate(text = str_replace_all(text  , replace_reg, ''),
      row.id = row_number()) %>%
    unnest_tokens(
      word,
      text,
      token = 'regex',
      pattern = unnest_reg,
      collapse = F) %>%
    mutate(mentioned = ifelse(str_detect(word, '@'), word, NA))
  golf <- filter(golf, mentioned != "@" | is.na(mentioned))
  Spectral_n <- colorRampPalette(brewer.pal(11, 'Spectral'))

  tweet_g <- golf %>% 
    transmute(screen_name = str_to_lower(str_c('@', screen_name)),
        mentioned) %>%
    na.omit() %>%
    graph_from_data_frame() %>% # from igraph
    simplify()
    
  tweet_edges <- tweet_g %>%
    as_data_frame() %>%
    as_tibble() %>%
    mutate_all(funs(str_trim(.)))
  edge_col <- tweet_edges %>%
    mutate(betweenness = edge.betweenness(tweet_g)) %>%
    arrange(betweenness) %>%
    distinct(from) %>%
    mutate(color = sample(Spectral_n(nrow(.)))) %>%
    right_join(tweet_edges) %>%
    select(name = from, to, color)

  tweet_nodes <- tweet_g %>%
    as_data_frame(., 'vertices') %>%
    as_tibble() %>%
    mutate_all(funs(str_trim(.)))

  node_col_temp <- tweet_nodes %>%
    mutate(in.degree = degree(tweet_g, mode = 'in')) %>%
    left_join(edge_col) %>%
    select(-to) %>%
    distinct() %>%
    filter(is.na(color)) %>%
    distinct() %>%
    filter(in.degree == 1) %>%
    pull(name)

  node_add <- edge_col %>%
    filter(to %in% node_col_temp) %>%
    select(name = to, color.2 = color)

  n_shared_node <- tweet_nodes %>%
    left_join(edge_col) %>%
    select(-to) %>%
    distinct() %>%
    left_join(node_add) %>%
    mutate_all(funs(ifelse(is.na(.), '', .))) %>%
    unite(color, color, color.2, sep = '') %>%
    filter(color == '') %>%
    nrow()

  node_col <- tweet_nodes %>%
    left_join(edge_col) %>%
    select(-to) %>%
    distinct() %>%
    left_join(node_add) %>%
    mutate_all(funs(ifelse(is.na(.), '', .))) %>%
    unite(color, color, color.2, sep = '') %>%
    mutate(color = ifelse(color == '', Spectral_n(n_shared_node), color))
    
  edge.cols.ad <- map2(edge_col$color,
    rescale(edge.betweenness(tweet_g), 0.5, 1),     
    function(x, y) {
     adjustcolor(x, y)
    }) %>% 
    flatten_chr()

  node.cols.ad <- map2(node_col$color, 
    rescale(degree(tweet_g), 0.5, 1), 
      function(x, y){
        adjustcolor(x, y)
      }) %>% 
    flatten_chr()
  all <- unique(c(tweet_edges$from, tweet_edges$to))
  nodes <- lapply(all, function(x) list(name = x))
  links <- tweet_edges
  links[] <- lapply(links, function(col) as.numeric(factor(col, levels = all)) - 1)
  links <- lapply(seq_len(nrow(links)), function(i) {
    list("source" = links[i, "from", drop = TRUE],
    "target" = links[i, "to", drop = TRUE])
  })

  graph_data <- list(
    nodes = nodes,
    links = links
  )
  saveRDS(tweet_g, here("data/tweet_g.rds"))
  saveRDS(graph_data, here("data/graph_data.rds"))
} else {
  tweet_g <- readRDS(here("data/tweet_g.rds"))
  graph_data <- readRDS(here("data/graph_data.rds"))
}

## ------------------------------------------------------------------------
d <- igraph_to_networkD3(tweet_g)
d$nodes$group <- 1
forceNetwork(
  Links = d$links, 
  Nodes = d$nodes,
  NodeID = "name",
  Group = "group",
  zoom = TRUE
)

## ------------------------------------------------------------------------
datasaurus_dozen$dataset <- factor(datasaurus_dozen$dataset,
    levels = c(
        "away", 
        "high_lines", 
        "wide_lines",
        "h_lines", 
        "v_lines",
        "slant_down", 
        "slant_up", 
        "dots",
        "bullseye",
        "circle",
        "star", 
        "x_shape",
        "dino")
    )

ax <- list(
  title = "",
  zeroline = FALSE,
  showline = FALSE,
  showticklabels = FALSE,
  showgrid = FALSE
)

plot_ly(datasaurus_dozen, 
    x = ~x, 
    y = ~y, 
    frame = ~dataset, 
    mode = "markers",
    type = "scatter",
    showlegend = FALSE) %>%
    layout(xaxis = ax, yaxis = ax) %>%
    animation_opts(frame = 2500, transition = 500)

## ---- fig.height = 1, fig.width = 1--------------------------------------
createWidget(
  "hello_world",
  x = list(),
  package = "plotlyutils"
)

## ---- fig.height = 1, fig.width = 1--------------------------------------
createWidget(
  "hello_edinbr",
  x = list(),
  package = "plotlyutils"
)

## ------------------------------------------------------------------------
createWidget(
  "twitternetwork",
  x = graph_data,
  sizingPolicy = sizingPolicy(
    browser.fill = TRUE, 
    viewer.fill = TRUE
  ),
  package = "plotlyutils"
)

## ------------------------------------------------------------------------
suppressPackageStartupMessages({
  library("plotlyutils")
  library("plotly")
})

set.seed(42)
tt <- GBMtopTable[sample(seq_len(nrow(GBMtopTable)), 1000), ]
title <- "Glioblastoma - IDH1 mutant vs wt"
xtitle <- "log<sub>2</sub>(fold-change)"
ytitle <- "-log<sub>10</sub>(FDR-adjusted p-value)"
colours <- c("#0000ff", "#000000", "#ff0000")
linked_scatter_plot(
    x = tt[["logFC"]],
    xlab = xtitle,
    y = -log10(tt[["adj.P.Val"]]),
    ylab = ytitle,
    xlim = c(-max(abs(tt[["logFC"]])), max(abs(tt[["logFC"]]))) * 1.1,
    text = tt[["Text"]],
    links = tt[["Links"]],
    groups = tt[["Group"]],
    title = title,
    colours = colours)

## ------------------------------------------------------------------------
suppressPackageStartupMessages({
    library("plotlyutils")
    library("SummarizedExperiment")
    library("limma")
})
pcs <- prcomp(t(voomed_GBM$E))
pc_data <- pcs$x

columns <- c(
    "subtype_IDH.status",
    "subtype_Age..years.at.diagnosis.",
    "subtype_Gender",
    "subtype_Pan.Glioma.RNA.Expression.Cluster",
    "ethnicity"
)
colours <- colData(GBMdata)[, columns, drop = FALSE]
colours <- as.data.frame(colours)
colnames(colours) <- gsub("subtype_", "", colnames(colours))
colours$TotalReads <- colSums(assay(GBMdata))


plot(
    pc_data[, 1], 
    pc_data[, 2], 
    col = as.factor(colours[[1]]),
    pch = 16,
    xlab = "PC1",
    ylab = "PC2")
legend(
    max(pc_data[, 1]) * 0.7,
    max(pc_data[, 2]) * 0.7,
    unique(colours[[1]]),
    pch = 16,
    col = unique(colours[[1]]))


## ------------------------------------------------------------------------
selectable_scatter_plot(pc_data, colours)

