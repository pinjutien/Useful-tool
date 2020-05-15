import pandas_datareader.data as web
from datetime import datetime
import pandas as pd
import numpy as np
import math
from scipy.optimize import minimize
from functools import partial
from scipy.optimize import LinearConstraint
from copy import copy
from random import shuffle
from pprint import pprint
from monthdelta import monthdelta

pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 500)
pd.set_option('display.width', 1000)

def stock_data(index_choice, start, end, target):
    """
    import pandas_datareader.data as web
    from datetime import datetime
    start = datetime(2016, 9, 1)
    end = datetime(2018, 9, 1)
    f = web.DataReader('F', 'iex', start, end)
    """
    
    res = []
    output_cols = []
    output_cols_r = []
    for x in index_choice:
        output_cols += [target + "_" + x]
        output_cols_r += [target + "_r_" + x]
        temp_v0 = web.DataReader(x, data_source).reset_index(["symbol"])
        temp_v0[target] = temp_v0[target].astype(np.float32)
        temp_v0[target + "_r"] = temp_v0[target].pct_change()
        temp = temp_v0.reset_index()[["begins_at", target, target + "_r"]]\
               .rename(columns = {target: target + "_" + x,
                                  target + "_r" : target + "_r_" + x})
        
        # temp[target + "_" + x] = temp[target + "_" + x].astype(np.float32)
        if (len(res) == 0):
            res = temp
        else:
            res = pd.merge(res, temp, on = "begins_at")

        # res += [web.DataReader(x, 'robinhood', start, end).reset_index()[[target]].rename(
        #     columns = {target: target + "_" + x}
        # )]
        
    # res_x = pd.DataFrame(res[output_cols])
    return (pd.DataFrame(res.set_index(["begins_at"]).loc[start : end]),
            output_cols,
            output_cols_r)

def portfolio_std(w, sigma, rho):
    
    # https://en.wikipedia.org/wiki/Modern_portfolio_theory
    x1 = np.multiply(w, sigma)
    x2 = np.dot(x1, rho)
    y = np.dot(x2, x1)
    
    return y


if __name__ == '__main__':

    # index_choice = ["VOO", "JPM", "PHO", "DBX", "SQ", "NFLX", "FB"]
    # index_choice = ["VOO", "JPM", "PHO", "SQ", "NFLX", "DBX", "FB", "VWO"]
    index_choice = ["PHO", "VOO", "VTI", "VEA", "VWO", "VTV", "VUG", "VNQ", "VIG", "VB", "VO", "VGT", "BSV"]
    target = "close_price"
    data_source = 'robinhood'
    # start = datetime(2018, 8, 18)
    # end = datetime(2018, 9, 18)
    start = "2018-08-18"
    end = "2018-09-18"
    
    (df, target_cols, return_rate_cols) = stock_data(index_choice, start, end, target)
    num_row = df.shape[0]
    rho_df = df[target_cols].corr()
    print("correlation matrix:")
    print(rho_df)
    print("\n")
    cols = rho_df.columns.values 
    sigma = df[cols].std()/math.sqrt(num_row)
    # w = [1] * len(cols)
    obj_f = partial(portfolio_std,
                    sigma = sigma.values,
                    rho = rho_df.values)

    x0 = [1.0/len(cols)] * len(cols)
    bounds = tuple([ (0.00001,1.0) for i in range(len(cols))])
    # linear_constraint = LinearConstraint([[1, 1], [1, 1]], [1, 1], [1, 1])
    # res = minimize(obj_f,
    #                x0,
    #                method='trust-constr',
    #                tol=1e-6,
    #                bounds=bounds,
    #                constraints=[linear_constraint],
    #                options={'verbose': 1})

    con1 = lambda x: np.sum(x) -1.0

    cons = [{'type':'eq', 'fun': con1}]
    res = minimize(obj_f,
                   x0,
                   bounds=bounds,
                   constraints=cons)
    w = res.x
    obj_v = portfolio_std(w, sigma.values, rho_df.values)
    print("risk values: ", obj_v)
    summary = dict(zip(cols, w))
    pprint(summary)
    print("\n")
    
    # shuffle w
    # random_w = copy(w)
    # s = 1
    # while((random_w == w).all()):
    #     shuffle(random_w)

    # random_obj_v = portfolio_std(random_w, sigma.values, rho_df.values)
    # print("obj values from random w: ", random_obj_v)
    # summary = dict(zip(cols, random_w))
    # pprint(summary)
    
