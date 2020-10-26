function saveFigAsPDF(figHandle,fileName)
    set(figHandle,'Units','Inches');
    pathFigPos = get(figHandle,'Position');
    set(figHandle,'PaperPositionMode','Auto','PaperUnits','Inches',...
        'PaperSize',[pathFigPos(3), pathFigPos(4)])
    print(figHandle,fileName,'-dpdf','-r0')
end

