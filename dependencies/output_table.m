function output_table(Values, rowLabels)
    normTable = table(Values, 'RowNames', rowLabels);
    disp(normTable)
end