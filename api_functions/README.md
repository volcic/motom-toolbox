Here are some notes on why things look so strange in here.

I had to separate 32 and 64-bit stuff. I did this by literally looking for a file I generated, in new_or_old.m.
I am returning all the passed values to the functions. Here's why.
The API functions sometimes only accept pointers, which means that the NDI API is allowed to meddle with some shared memory. This is a nice and a fast way to write things into in the machine, but Matlab hates it. Generally, in Matlab, overwriting a function's input argument during function call by the function itself is bad practice. And doing this via an external library leads to access violations, which causes it to crash ever so often. I generated the pointers myself including typecasting NDI's own structures and variable types so NDI's software can do its thing within the space of the function, and Matlab will take care of the memory management.
So, all the input variables are return variables too, so Matlab will return them if they were 'normal' functions. Also, this way you can see if there have been variable corruption due to type conversion.
I also added a fail variable to be the very first return value, which helps debugging. If you don't want to handle all return parameters, ignore it with a tilde:
```
    [fail, variable_you_want, ~] = function(variable_you_want, variable_you_don't_want);

    if(fail)
	fprintf('the cleverly written function above that should never fail has failed.\n')
    end
```
