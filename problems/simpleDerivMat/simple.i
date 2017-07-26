[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 1
  ny = 1
[]

[Variables]
  [./diffused]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./diff]
    type = MatDiffusion
    variable = diffused
    D_name = diffusivity
  [../]
[]

[BCs]
  [./bottom]
    type = DirichletBC
    variable = diffused
    boundary = 'bottom'
    value = 1
  [../]

  [./top]
    type = DirichletBC
    variable = diffused
    boundary = 'top'
    value = 0
  [../]
  [./left]
    type = DirichletBC
    variable = diffused
    boundary = 'left'
    value = 1
  [../]
  [./right]
    type = DirichletBC
    variable = diffused
    boundary = 'right'
    value = 0
  [../]
[]

[Materials]
  [./blockDiffusivity]
    type = DerivativeParsedMaterial
    f_name = diffusivity
    function  = '1.0'
    args = diffused
    derivative_order = 1
  [../]
[]

# [Materials]
#   [./blockDiffusivity]
#     type = GenericConstantMaterial
#     prop_names = 'D'
#     prop_values = '1'
#   [../]
# []

[Executioner]
  type = Transient
  num_steps = 1
  solve_type = 'PJFNK'
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]

[MultiApps]
  [./loopApp]
    type = TransientMultiApp
    app_type = MoltresApp
    execute_on = timestep_begin
    positions = '0 0 0.0'
    input_files = 'sub_simple.i'
  [../]
[]
