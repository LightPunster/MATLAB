function legappend(new_entry)

    old_legend = findobj(gcf, 'Type', 'Legend');

    try
        old_legend.String{end} = new_entry;
        legend(old_legend.String)
    catch
        legend(new_entry)
    end

end