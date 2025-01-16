# Progress monitor for MATLAB
This is a simple progress monitor for MATLAB. It monitors the progress of __parfor__ loops or regular __for__ loops in MATLAB.

## INPUT arguments

```MATLAB
%%% inputs:
% total_num: total number of iterations.
% title: title of the progress monitor.
% print_step: print progress every print_step.
```
Pass inputs as:

```MATLAB
progress_monitor = ProgressMonitor(total_num, title_str, print_step);
```

or 

```MATLAB
progress_monitor = ProgressMonitor(total_num, title_str);
```

or

```MATLAB
progress_monitor = ProgressMonitor(total_num);
```

## Usages

For a __parfor__ loop

```MATLAB
progress_monitor = ProgressMonitor(total_num, 'Parallel progress:');
parfor i = 1 : total_num
    % do something
    progress_monitor.finish_index(i); %#ok<PFBNS>
end
```

For a __for__ loop

```MATLAB
progress_monitor = ProgressMonitor(total_num, 'Loop progress:');
for i = 1 : total_num
    % do something
    progress_monitor.finish_index(i);
end
```






