def sim_tryparams_ddm(task, values, par_name, base_params):
    """
    Simulate DDM data for different parameter values (changing only one param)
    
    Currently...
    -DDM must have v_x and v_intercept (a la Ariel Zylberberg)

    Parameters
    ----------
    task : pandas.DataFrame
        DataFrame containing the 'x' column for scaling drift rates
    values : array-like
        List or array of parameter values to simulate
    par_name: str
        The parameter we are trying
    base_params : dict
        Base parameters for the DDM (those that we don't want to change).
    
    Returns
    -------
    pandas.DataFrame
        Combined dataset containing all simulations
    
    -------
    # Example usage:
    task = gen_dm_task([-0.5,-0.25,-0.15,0.15,0.25,0.5],1000)
    values = [3.0,8.0]
    custom_params = {
        'a': 2.0,
        'z': 0.5,
        't': 0.3,
        'v_intercept': 0.1
    }
    dataset = sim_tryparams_ddm(task, values, par_name = 'v_x', base_params=custom_params)
    """
    
    # Initialize list to store datasets
    datasets = []
    
    # Simulate for each v_x value
    for p2try in values:
        # assemble the base params
        base_params[par_name] = p2try

        # Calculate drift rate
        v_reg_v = base_params['v_intercept'] + (base_params['v_x'] * task["x"].to_numpy())
        
        # Create parameter dictionary for this simulation
        param_dict = {
            'a': base_params['a'],
            'z': base_params['z'],
            't': base_params['t'],
            'v': v_reg_v
        }
        
        # Simulate data
        dataset = hssm.simulate_data(model="ddm", theta=param_dict, size=1)
        
        # Add condition information
        dataset["x"] = task['x']
        dataset[par_name] = p2try
        
        datasets.append(dataset)
    
    # Combine all datasets
    return pd.concat(datasets, ignore_index=True)