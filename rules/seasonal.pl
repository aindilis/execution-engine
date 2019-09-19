%% after any major holiday, look for deals for both holiday related
%% merchandise (to get for the next year at a discounted price), and
%% general holiday merchandise like discounted candy.

%% prepare for the encroachment of ants during the beginning of the
%% summer


%% Spring %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% - Cleaning

(clean(crawlspace),prepareFor(stormSeason)) :-
	livesInTemperateClimate(user), seasonBeginning(spring),
	has(user,Space), ( Space = crawlspace ; Space = garage ).

%% Summer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Fall   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clean(crawlspace) :-
	livesInTemperateClimate(user), seasonBeginning(fall),
	has(user,garage).

%% Winter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
