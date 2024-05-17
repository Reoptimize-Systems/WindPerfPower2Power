function path = p2p_git_dir ()
% returns the root directory of the power to power folder in github

    mfile = mfilename ();
    
    loc = which (mfile);

    if isempty (loc)
        error ('UTILS:nofile', 'm-file or class does not appear to exist')
    else
        path = fileparts (loc);
    end
    
end
