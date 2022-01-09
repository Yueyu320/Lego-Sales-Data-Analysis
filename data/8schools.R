library(rstan)

eight_schools = "
  data {
    int<lower=0> n;         // number of schools
    real y[n];              // estimated treatment effects
    real<lower=0> sigma[n]; // s.e. of effect estimates
  }
  
  parameters {
    real mu;           // mean effect for schools
    real<lower=0> tau; // variance
    vector[n] eta;       // individual school effect
  }
  
  transformed parameters {
    vector[n] theta;
    theta = mu + tau * eta;
  }
  
  model {
    target += normal_lpdf(eta | 0, 1);       // eta ~ N(0,1)
    target += normal_lpdf(y | theta, sigma); // y ~ N(theta, sigma^2)
  }
"

schools_data = list(
  n = 8,
  y = c(28,  8, -3,  7, -1,  1, 18, 12),
  sigma = c(15, 10, 16, 11,  9, 11, 10, 18)
)

fit = stan(
  model_code = eight_schools,   # Stan code
  data = schools_data,    # named list of data
  chains = 4,             # number of Markov chains
  warmup = 1000,          # number of warmup iterations per chain
  iter = 2000,            # total number of iterations per chain
  refresh = 100,          # show progress every 'refresh' iterations
  seed = 1234             # Random seed
)

df = tidybayes::gather_draws(fit, mu, tau, eta[i], theta[i])

saveRDS(df, "data/8schools.rds")
