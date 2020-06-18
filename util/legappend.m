function legappend(new_entry)
old_legend = findobj(gcf, 'Type', 'Legend');
old_legend.String{end} = new_entry;
legend(old_legend.String)
end