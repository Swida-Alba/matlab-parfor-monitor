%%% Usage:
% progress_monitor = ProgressMonitor(total_num, 'title');
% parfor i = 1 : total_num
%     % do something
%     progress_monitor.finish_index(i); %#ok<PFBNS>
% end

%%% or
% progress_monitor = ProgressMonitor(total_num, 'title');
% for i = 1 : total_num
%     % do something
%     progress_monitor.finish_index(i);
% end

%%% inputs:
% total_num: total number of iterations.
% title: title of the progress monitor.
% print_step: print progress every print_step.
% 
% pass inputs as:
%
% progress_monitor = ProgressMonitor(total_num, title_str, print_step);
% or 
% progress_monitor = ProgressMonitor(total_num, title_str);
% or
% progress_monitor = ProgressMonitor(total_num);

classdef ProgressMonitor < handle

    properties
        total_num;
        count;
        title;
        char_count;
        t_start;
        data_queue;
        print_step; % print progress every print_step.
    end

    methods
        function obj = ProgressMonitor(total_num, title_str, print_step)

            if nargin > 0
                obj.total_num = total_num;
            else
                error('Please provide total number of iterations');
            end

            if nargin > 1
                obj.title = title_str;
            else
                obj.title = 'Progress Monitor: ';
            end

            if nargin > 2
                obj.print_step = print_step;
            else
                obj.print_step = 1;
            end
            
            obj.count = 0;
            obj.char_count = 0;
            obj.t_start = tic;
            obj.data_queue = parallel.pool.DataQueue;
            afterEach(obj.data_queue, @(~) obj.increment());
        end

        function increment(obj)
            obj.count = obj.count + 1;
            t_now = toc(obj.t_start);
            completed_percent = obj.count / obj.total_num * 100;
            t_est = t_now / obj.count * (obj.total_num - obj.count);
            t_str = char(duration(0, 0, t_est, 'Format', 'hh:mm:ss.SSS'));

            if mod(obj.count, obj.print_step) ~= 0
                return;
            end
            
            fprintf(repmat('\b', 1, obj.char_count));
            if  obj.count > 5
                obj.char_count = fprintf('%s %d/%d -- %.2f%%. Elapsed %.2f s. Remaining %s\n', obj.title, obj.count, obj.total_num, completed_percent, t_now, t_str);
            else
                obj.char_count = fprintf('%s %d/%d -- %.2f%%. Elapsed %.2f s. Estimating time\n', obj.title, obj.count, obj.total_num, completed_percent, t_now);
            end

        end

        function finish_index(obj, ind)
            send(obj.data_queue, ind);
        end

    end

end
