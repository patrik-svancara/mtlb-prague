% Repeats VoroTestRichPoor for various FINALPTS values

ALLFINALPTS = 50:5:100;

for fptsind = 1:length(ALLFINALPTS)
    
   FINALPTS = ALLFINALPTS(fptsind); 
   
   VoroTestRichPoor;
   
   allst(fptsind).poorst = poorst;
   allst(fptsind).richst = richst;
   
   % plot for the user
   for a = 1:fptsind
       poorstd(a) = allst(a).poorst.mom(4);
       richstd(a) = allst(a).richst.mom(4); 
   end
   
   plot(ALLFINALPTS(1:fptsind),poorstd,'+-','LineWidth',1.3);
   hold on;
   plot(ALLFINALPTS(1:fptsind),richstd,'+-','LineWidth',1.3);
   hold off;
   title(FINALPTS);
   legend('poor','rich','Location','best');
   
   pause(1);
   
end
   