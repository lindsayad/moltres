k_coeff = 1

[Mesh]
  type = GeneratedMesh
  nx = 999
  dim = 1
[]

[Kernels]
  [./source]
    type = UserForcingFunction
    variable = u
    function = 'forcing_func'
  [../]
  [./convection]
    type = ConservativeAdvection
    variable = u
    velocity = '200 0 0'
  [../]
  [./diffusion]
    type = MatDiffusion
    variable = u
    D_name = 'k'
  [../]
  [./supg]
    type = AdvectionSUPG
    variable = u
    D_name = 'k'
    velocity = '200 0 0'
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
    boundary = 'left right'
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
  petsc_options_iname = '-pc_type -sub_pc_type -sub_ksp_type'
  petsc_options_value = 'asm      lu           preonly'

  solve_type = 'NEWTON'
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
    value = 'x^2'
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
