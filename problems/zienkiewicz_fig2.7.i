k_coeff = 0
vel = 1

[Mesh]
  type = GeneratedMesh
  xmax = 15
  nx = 15
  dim = 1
[]

[Kernels]
  [./source]
    type = UserForcingFunction
    variable = u
    function = 'forcing_func'
  [../]
  # [./source_supg]
  #   type = UserForcingFunctionSUPG
  #   variable = u
  #   function = 'forcing_func'
  #   velocity = '${vel} 0 0'
  #   D_name = 'k'
  # [../]
  [./convection]
    type = NonConservativeAdvection
    variable = u
    velocity = '${vel} 0 0'
  [../]
  # [./diffusion]
  #   type = MatDiffusion
  #   variable = u
  #   D_name = 'k'
  # [../]
  [./supg]
    type = AdvectionSUPG
    variable = u
    D_name = 'k'
    velocity = '${vel} 0 0'
  [../]
[]

[BCs]
  # [./outflow]
  #   type = OutflowBC
  #   boundary = 'left right'
  #   variable = u
  #   velocity = '1 0 0'
  # [../]
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
  type = Steady
  petsc_options = '-snes_converged_reason -ksp_converged_reason -snes_linesearch_monitor'
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'asm'
  # petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -snes_linesearch_minlambda'
  # petsc_options_value = 'lu NONZERO 1e-10 1e-3'
  nl_max_its = 20
  l_max_its = 30

  solve_type = 'PJFNK'
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Functions]
  [./forcing_func]
    type = ParsedFunction
    # value = 'x^2'
    value = 'if(x < 6, 1 - .25*x, if(x < 8, -2 + .25*x, 0))'
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
