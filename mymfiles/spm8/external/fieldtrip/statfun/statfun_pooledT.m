function [s] = statfun_pooledT(cfg, dat, design)

% STATFUN_pooledT computes the pooled t-value over a number of
% replications. The idea is that you compute a contrast between two
% conditions per subject The t-values are pooled over subjects and
% compared against the pooled pseudo-values. Since according to H0
% the expected t-value for each subject value is zero, the difference
% between the pooled t-value and the pseudo-value (which is set to
% zero) is a fixed-effects statistic.
% 
% The computation of the difference between pooled t-values can be
% repeated after randomly permuting the t-values and pseudo-values
% within the subjects. Each random permutation gives you an estimate
% of the difference. The random permutations build up a randomization
% distributin, against which you can compare the observed pooled
% t-values.
% 
% The statistical inference based on the comparison of the observed
% pooled t-values with the randomization distribution is not a
% fixed-effect statistic, one or a few outlier will cause the
% randomization distribution to broaden and result in the conclusion
% of "not significant".
% 
% Use this function by calling one of the high-level statistics
% functions as
%   [stat] = ft_timelockstatistics(cfg, timelock1, timelock2, ...)
%   [stat] = ft_freqstatistics(cfg, freq1, freq2, ...)
%   [stat] = ft_sourcestatistics(cfg, source1, source2, ...)
% with the following configuration option:
%   cfg.statistic = 'pooledT'
%
% Configuration options that are relevant for this function are
%   cfg.ivar = number, index into the design matrix with the independent variable
%
% See FT_TIMELOCKSTATISTICS, FT_FREQSTATISTICS or FT_SOURCESTATISTICS
% for details.

selA = find(design(cfg.ivar,:)==1);
selB = find(design(cfg.ivar,:)==2);
dfA  = length(selA);
dfB  = length(selB);
if (dfA+dfB)<size(design, 2)
  error('inappropriate design, should only contain 1''s and 2''s');
end
sumA = sum(dat(:,selA), 2);
sumB = sum(dat(:,selB), 2);
s = (sumA - sumB)./sqrt(dfA);

s.stat = s;
