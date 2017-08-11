# pitzDaily
uin = 10
# cbc = .003
# kin = ${* ${cbc} ${* ${uin} ${uin}}}
# l0 = 25.4
# cmu = 0.09
# epsin = ${* ${cmu} ${/ ${* ${kin} ${kin}} ${l0}}} # Should be kin^(3/2)
kin = .375
epsin = 14.855

[GlobalParams]
  gravity = '0 0 0'
  integrate_p_by_parts = true
  use_exp_form = false
[]

[Mesh]
  file = 'pitzDaily.msh'
[]

# [MeshModifiers]
#   [./corner_node]
#     type = AddExtraNodeset
#     new_boundary = 'pinned_node'
#     coord = '0 0'
#   [../]
# []

[Variables]
  [./vel_x]
    order = SECOND
    family = LAGRANGE
  [../]
  [./vel_y]
    order = SECOND
    family = LAGRANGE
  [../]
  [./p]
    order = FIRST
    family = LAGRANGE
  [../]
  [./kin]
    family = LAGRANGE
    order = SECOND
    initial_condition = 1e-6
  [../]
  [./epsilon]
    family = LAGRANGE
    order = SECOND
    initial_condition = 1e-6
  [../]
[]

[Kernels]
  [./mass]
    type = INSMass
    variable = p
    u = vel_x
    v = vel_y
  [../]
  [./x_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_x
    u = vel_x
    v = vel_y
    p = p
    component = 0
  [../]
  [./y_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_y
    u = vel_x
    v = vel_y
    p = p
    component = 1
  [../]
  [./x_supg]
    type = INSMomentumSUPG
    u = vel_x
    v = vel_y
    component = 0
    variable = vel_x
    p = p
  [../]
  [./y_supg]
    type = INSMomentumSUPG
    u = vel_x
    v = vel_y
    component = 1
    variable = vel_y
    p = p
  [../]
  [./x_time_deriv]
    type = INSMomentumTimeDerivative
    variable = vel_x
  [../]
  [./y_time_deriv]
    type = INSMomentumTimeDerivative
    variable = vel_y
  [../]
  [./x_time_deriv_supg]
    type = INSMomentumTimeDerivativeSUPG
    variable = vel_x
    u = vel_x
    v = vel_y
  [../]
  [./y_time_deriv_supg]
    type = INSMomentumTimeDerivativeSUPG
    variable = vel_y
    u = vel_x
    v = vel_y
  [../]
  [./vel_x_turb]
    type = INSMomentumTurbulentViscosityLaplaceForm
    variable = vel_x
    component = 0
    u = vel_x
    v = vel_y
    kin = kin
    epsilon = epsilon
  [../]
  [./vel_y_turb]
    type = INSMomentumTurbulentViscosityLaplaceForm
    variable = vel_y
    component = 1
    u = vel_x
    v = vel_y
    kin = kin
    epsilon = epsilon
  [../]
  [./kin]
    type = INSK
    variable = kin
    u = vel_x
    v = vel_y
    epsilon = epsilon
  [../]
  [./epsilon]
    type = INSEpsilon
    variable = epsilon
    u = vel_x
    v = vel_y
    kin = kin
  [../]
  [./kin_time]
    type = INSScalarTransportTimeDerivative
    variable = kin
  [../]
  [./epsilon_time]
    type = INSScalarTransportTimeDerivative
    variable = epsilon
  [../]
[]

[BCs]
  [./x_no_slip]
    type = DirichletBC
    variable = vel_x
    boundary = 'walls'
    value = 0.0
  [../]
  [./y_no_slip]
    type = DirichletBC
    variable = vel_y
    boundary = 'walls'
    value = 0.0
  [../]
  [./x_inlet]
    type = FunctionDirichletBC
    variable = vel_x
    boundary = 'inlet'
    function = 'inlet_func'
  [../]
  [./kin_inlet]
    type = DirichletBC
    variable = kin
    value = ${kin}
    boundary = 'inlet'
  [../]
  [./epsin_inlet]
    type = DirichletBC
    variable = epsilon
    value = ${epsin}
    boundary = 'inlet'
  [../]
  # [./epsilon_walls]
  #   type = INSEpsilonWallFunctionBC
  #   variable = epsilon
  #   kin = kin
  #   boundary = 'walls'
  # [../]
  # [./x_outlet]
  #   type = INSMomentumNoBCBCLaplaceForm
  #   variable = vel_x
  #   u = vel_x
  #   v = vel_y
  #   p = p
  #   component = 0
  #   boundary = 'outlet'
  # [../]
  # [./y_outlet]
  #   type = INSMomentumNoBCBCLaplaceForm
  #   variable = vel_y
  #   u = vel_x
  #   v = vel_y
  #   p = p
  #   component = 1
  #   boundary = 'outlet'
  # [../]
  # [./pressure_pin]
  #   type = DirichletBC
  #   variable = p
  #   boundary = 'pinned_node'
  #   value = 0
  # [../]
[]

[Materials]
  [./const]
    type = GenericConstantMaterial
    block = 'interior'
    prop_names = 'rho mu'
    prop_values = '1  1'
  [../]
[]

[Preconditioning]
  [./SMP_PJFNK]
    type = FDP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  # petsc_options_iname = '-ksp_gmres_restart -pc_type -sub_pc_type -sub_pc_factor_levels'
  # petsc_options_value = '300                bjacobi  ilu          4'
  solve_type = 'NEWTON'
  petsc_options = '-snes_converged_reason -ksp_converged_reason -snes_linesearch_monitor'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -snes_linesearch_minlambda'
  petsc_options_value = 'lu NONZERO 1.e-10 1e-3'
  line_search = none
  nl_max_its = 20
  l_max_its = 30
  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-6
  end_time = 100000
  dtmin = .01
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = .01
    cutback_factor = 0.4
    growth_factor = 1.2
    optimal_iterations = 20
  [../]
[]

[Outputs]
  [./out]
    type = Exodus
  [../]
[]

[Functions]
  [./inlet_func]
    type = ParsedFunction
    value = ${uin}
    # value = '-4 * (y - 0.5)^2 + 1'
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]
