module Commands

mutable struct sydCommand
    Trigger::String
    Execute::Function
    
    function sydCommand(trigger, f)
    new(trigger,f) 
    end  
end 


end


