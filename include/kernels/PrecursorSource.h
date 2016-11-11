#ifndef PRECURSORSOURCE_H
#define PRECURSORSOURCE_H

#include "Kernel.h"
#include "ScalarTransportBase.h"

//Forward Declarations
class PrecursorSource;

template<>
InputParameters validParams<PrecursorSource>();

class PrecursorSource : public ScalarTransportBase<Kernel>
{
public:
  PrecursorSource(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const MaterialProperty<std::vector<Real> > & _nsf;
  const MaterialProperty<std::vector<Real> > & _d_nsf_d_temp;
  int _num_groups;
  const MaterialProperty<std::vector<Real> > & _beta_eff;
  const MaterialProperty<std::vector<Real> > & _d_beta_eff_d_temp;
  int _precursor_group;
  const VariableValue & _temp;
  unsigned int _temp_id;
  std::vector<const VariableValue *> _group_fluxes;
  std::vector<unsigned int> _flux_ids;
};

#endif //PRECURSORSOURCE_H
