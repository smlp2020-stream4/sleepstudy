# 3a
"""
  fixef_csv(m; out="fixef.csv", intercept="days_0") 

output the fixed effects of a fitted model to a csv file
Ben Bolker, 2020-08-21 (slightly modified)
https://stackoverflow.com/questions/32585319/export-linear-mixed-effects-model-outputs-in-csv-using-julia-language

"""
fixef_csv = function(m;  out="fixef.csv"; intercept="days_0")
    ct = coeftable(m);
    ct.rownms[1] = intercept;
    ct.colnms[1] = "beta";
    fixef = DataFrame(ct.cols);
    rename!(fixef, ct.colnms, makeunique = true)
    fixef[!, :term] = ct.rownms;
    CSV.write(out, fixef);
end

# Example
fixef_csv(m; outfn="fixef.csv", intercept="days_0")

# 3b
"""
    cms_csv(m, outfn="cms.csv", intercept="(Intercept)") 

output the conditional modes of a fitted model to a csv file
Reinhold Kliegl, 2020-08-28
"""

cms_csv = function(m; out="cms.csv", intercept="days_0")
    ct = DataFrame(ranef(m)[:1]) .+  m.β;
    rename!(ct, subj_order[:1], makeunique = true) 
    cms = DataFrame([[names(ct)]; collect.(eachrow(ct))], [:column; Symbol.(axes(ct, 1))])
    rename!(cms, ["Subj", fixef.term[1], fixef.term[2]], makeunique = true)
    CSV.write(out, cms);
end

# Example
cms_csv(m; outfn="cms.csv", intercept="days_0")

# 2
"""
    outfun(m, outfn="output.csv")

output the fixed effects of a fitted model to a csv file
Ben Bolker, 2020-08-21
https://stackoverflow.com/questions/32585319/export-linear-mixed-effects-model-outputs-in-csv-using-julia-language
"""
outfun = function(m, outfn="output.csv")
    ct = coeftable(m)
    coef_df = DataFrame(ct.cols);
    rename!(coef_df, ct.colnms, makeunique = true)
    coef_df[!, :term] = ct.rownms;
    CSV.write(outfn, coef_df);
end

# 1
# Does NOT work in VS Code as expected; possibly ok in Terminals
function restart()
    startup = """
        Base.ACTIVE_PROJECT[]=$(repr(Base.ACTIVE_PROJECT[]))
        Base.HOME_PROJECT[]=$(repr(Base.HOME_PROJECT[]))
        cd($(repr(pwd())))
        """
    cmd = `$(Base.julia_cmd()) -ie $startup`
    atexit(()->run(cmd))
    exit(0)
end