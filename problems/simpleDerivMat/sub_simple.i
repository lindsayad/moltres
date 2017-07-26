[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 1
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
