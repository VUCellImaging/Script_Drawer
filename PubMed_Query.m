clear all; clc

%% Import an Excel spreadsheet with the PI list using a readmatrix function introduced in MATLAB 2019a

opts = spreadsheetImportOptions; 
opts.VariableTypes = 'char';
opts.Sheet = 'PI List';
opts.DataRange = 'A2';

% An example spreadsheet is included in the repository. Modify the file path below accordingly. 

list=readmatrix('C:\Users\okovt\Desktop\PubMed_Search_List_Example.xlsx',opts);


%% set the search url for the PubMed API

% detailed documentation can be found at
% https://www.ncbi.nlm.nih.gov/books/NBK25499/ [The E-utilities In-Depth:
% Parameters, Syntax and More]

search = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&";

% The database is specified by adding db=pubmed to the search url above;
%

%% search the API

for i = 1:length([list])

url = search + "term=" + list{i,1} + "+vanderbilt+AND+2022/02:2023/03[dp]&retmax=100&retmode=json&usehistory=y&sort=pub+date";

% the search term consists of the imported PI name, vanderbilt, and the date of publication [dp] filter; the number of returned pmid's is
% adjusted with the retmax parameter; additionally, pmid's are sorted by the publication date
%
% More filters can be found at: https://pubmed.ncbi.nlm.nih.gov/help/.

data = webread(url);
disp(list{i,1})
disp(data.esearchresult.idlist)
disp(data.esearchresult.count)
list{i,2} = [data.esearchresult.idlist];
list{i,3} = [data.esearchresult.count];

% the search output will be stored in the 'list' cell array, with column 2 = pmid's and column 3 =  publication count

% After May 1, 2018, any computer (IP address) that submits more than three E-utility requests per second will receive an error message. 
% This limit applies to any combination of requests to EInfo, ESearch, ESummary, EFetch, ELink, EPost, ESpell, and EGquery
% It is possible to obtain an API key from NCBI to increase the limit to 10 requests/user
%

pause(1)

end

%% Use BioC API to access full-text PMC articles for text mining and information retrieval

% https://www.ncbi.nlm.nih.gov/research/bionlp/RESTful/pubmed.cgi/BioC_[format]/[ID]/[encoding]
%       The parameters are:
%           format: xml or json
%           PMC ID
%           encoding: unicode or ascii
% More information can be found at https://www.ncbi.nlm.nih.gov/research/bionlp/APIs/BioC-PMC/

%%% article full-text retrieval:
% pmc_url = "https://www.ncbi.nlm.nih.gov/research/bionlp/RESTful/pmcoa.cgi/BioC_json/PMC"+"6411462"+"/unicode"; 
% 
% article = webread(pmc_url);
% article_text =[data_keyword.documents.passages(:).text];

%%% search the text for a specific word (e.g., Nikon)
% k = strfind(article_text,'Nikon');

