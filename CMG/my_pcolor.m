function h = my_pcolor(varargin)
    [cax,args,nargs] = axescheck(varargin{:});

    cax = newplot(cax);
    nextPlot = cax.NextPlot;

    [x,y,c,psth_store,plot_check] = deal(args{1:5});
    
    %% plot matrix
    if plot_check == 1
        hh = surface(x,y,zeros(size(c)),c,'Parent',cax,'Linestyle','none','ButtonDownFcn', @show_psth_matrix);
    else
        hh = surface(x,y,zeros(size(c)),c,'Parent',cax,'Linestyle','none');
    end
    
    lims = [min(min(x)) max(max(x)) min(min(x)) max(max(x))];
    pbaspect([1 1 1]);

    %% ButtonDownFcn function
    function show_psth_matrix(~,~)
        coordinates = get(gca,'CurrentPoint');
        coordinates(1,1) = round(coordinates(1,1)+0.5);
        coordinates(1,2) = round(coordinates(1,2)+0.5);
        
        figure;
        imshow(psth_store{coordinates(1,1),coordinates(1,2)});
    end

   %%
    set(hh,'AlignVertexCenters','on');

    if ismember(nextPlot, {'replace','replaceall'})
        set(cax,'View',[0 90]);
        set(cax,'Box','on');
        if lims(2) <= lims(1)
            lims(2) = lims(1)+1;
        end
        if lims(4) <= lims(3)
            lims(4) = lims(3)+1;
        end
        axis(cax,lims);
    end
    if nargout == 1
        h = hh;
    end

    colormap jet;
    legend('off');
end