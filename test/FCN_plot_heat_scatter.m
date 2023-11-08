function [] = FCN_plot_heat_scatter(x,y,sensitivity)

% sensitivity default should be 100

idx_nan_x=isnan(x);
if sum(idx_nan_x)>0
    x(idx_nan_x)=[];
    y(idx_nan_x)=[];
end
idx_nan_y=isnan(y);
if sum(idx_nan_y)>0
    x(idx_nan_y)=[];
    y(idx_nan_y)=[];
end

if width(x)>1
x=x';
end

if width(y)>1
y=y';
end


X =x;
Y =y;

no_bins = 100;

[values, centers] = hist3([X Y], [no_bins no_bins]);

centers_X = centers{1,1};
centers_Y = centers{1,2};

binsize_X = abs(centers_X(2) - centers_X(1)) / 2;
binsize_Y = abs(centers_Y(2) - centers_Y(1)) / 2;
bins_X = zeros(no_bins, 2);
bins_Y = zeros(no_bins, 2);

for i = 1:no_bins
    bins_X(i, 1) = centers_X(i) - binsize_X;
    bins_X(i, 2) = centers_X(i) + binsize_X;
    bins_Y(i, 1) = centers_Y(i) - binsize_Y;
    bins_Y(i, 2) = centers_Y(i) + binsize_Y;
end

scatter_COL = zeros(length(X), 1);

onepercent = round(length(X) / 100);


for i = 1:length(X)

    % if (mod(i,onepercent) == 0)
    %     fprintf('.');
    % end            

    last_lower_X = NaN;
    last_higher_X = NaN;
    id_X = NaN;

    c_X = X(i);
    last_lower_X = find(c_X >= bins_X(:,1));
    if (~isempty(last_lower_X))
        last_lower_X = last_lower_X(end);
    else
        last_higher_X = find(c_X <= bins_X(:,2));
        if (~isempty(last_higher_X))
            last_higher_X = last_higher_X(1);
        end
    end
    if (~isnan(last_lower_X))
        id_X = last_lower_X;
    else
        if (~isnan(last_higher_X))
            id_X = last_higher_X;
        end
    end

    last_lower_Y = NaN;
    last_higher_Y = NaN;
    id_Y = NaN;

    c_Y = Y(i);
    last_lower_Y = find(c_Y >= bins_Y(:,1));
    if (~isempty(last_lower_Y))
        last_lower_Y = last_lower_Y(end);
    else
        last_higher_Y = find(c_Y <= bins_Y(:,2));
        if (~isempty(last_higher_Y))
            last_higher_Y = last_higher_Y(1);
        end
    end
    if (~isnan(last_lower_Y))
        id_Y = last_lower_Y;
    else
        if (~isnan(last_higher_Y))
            id_Y = last_higher_Y;
        end
    end

    scatter_COL(i) = values(id_X, id_Y);

end

scatter(x, y, 50, scatter_COL, '.' );
colormap('jet');
h = colorbar;
clim([0 sensitivity]);

box on


end