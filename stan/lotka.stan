functions {
    vector ode_rhs(real t, vector u, real p1, real p2, real p3, real p4) {
        vector[2] du;
        du[1] = p1 * u[1] -p2 * u[1] * u[2];
        du[2] = -p3 * u[2] + p4 * u[1] * u[2];
        return du;
    }
}
data {
    vector[2] u0;
    int<lower=1> T;
    real u[T,2];
    real t0;
    real ts[T];
}
parameters {
    real<lower=0> sigma;
    real<lower=0.5,upper=2.5> p1;
    real<lower=0.0,upper=2.0> p2;
    real<lower=1.0,upper=4.0> p3;
    real<lower=0.0,upper=2.0> p4;
}
model{
    array[T] vector[2] u_hat;
    sigma ~ inv_gamma(2.0, 3.0);
    p1 ~ normal(1.5, 0.5);
    p2 ~ normal(1.2, 0.5);
    p3 ~ normal(3.0, 0.5);
    p4 ~ normal(1.0, 0.5);
    u_hat = ode_rk45_tol(ode_rhs, u0, t0, ts, 1e-3, 1.0e-6, 1000, p1,p2,p3,p4);
    for (t in 1:T){
        u[t,:] ~ normal(u_hat[t,1:2],sigma);
    }
}
