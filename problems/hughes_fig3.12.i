k_coeff = 0
vel = 1

[Mesh]
  type = GeneratedMesh
  xmax = 100
  nx = 101
  dim = 1
[]

[Kernels]
  [./convection]
    type = NonConservativeAdvection
    variable = u
    velocity = '${vel} 0 0'
  [../]
  [./supg]
    type = AdvectionSUPG
    variable = u
    D_name = 'k'
    velocity = '${vel} 0 0'
  [../]
  [./time]
    type = TimeDerivative
    variable = u
  [../]
  # [./time_supg]
  #   type = TimeDerivativeSUPG
  #   velocity = '${vel} 0 0'
  #   D_name = 'k'
  #   variable = u
  # [../]
[]

[BCs]
  [./diri]
    type = DirichletBC
    value = 0
    boundary = 'left'
    variable = u
  [../]
[]

[Problem]
[]

[Variables]
  [./u]
    family = LAGRANGE
    order = FIRST
  [../]
[]

[Materials]
  [./test]
    block = 0
    type = GenericConstantMaterial
    prop_names = 'k'
    prop_values = ${k_coeff}
  [../]
[]

[Executioner]
  type = Transient
  petsc_options = '-snes_converged_reason -ksp_converged_reason -snes_linesearch_monitor'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -snes_linesearch_minlambda'
  petsc_options_value = 'lu NONZERO 1e-10 1e-3'
  [./TimeIntegrator]
    type = CrankNicolson
  [../]
  nl_max_its = 20
  l_max_its = 30
  solve_type = 'PJFNK'
  dt = 0.5
  num_steps = 200
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Functions]
  [./ini_func]
    type = ParsedFunction
    # value = 'x^2'
    value = 'if(x < 20, sin(pi * x / 20), 0)'
  [../]
[]

[ICs]
  [./u]
    type = FunctionIC
    function = 'ini_func'
    variable = u
  [../]
[]

[Outputs]
  print_perf_log = true
  print_linear_residuals = true
  [./out]
    type = Exodus
    execute_on = 'timestep_end initial'
  [../]
[]
