/* SWIG interface file for VMask.
 */

%module VMask
%{
#include <stdexcept>
#include <vips/vipscpp.h>
%}

%import "VError.i"
%import "VImage.i"

/* Need to override assignment to get refcounting working.
 */
%rename(__assign__) *::operator=;


%rename(__index__) vips::VIMask::operator[];
%rename(__index__) vips::VDMask::operator[];

/* () is 2d array subscript, how odd!
 */
%rename(__call__) vips::VIMask::operator();
%rename(__call__) vips::VDMask::operator();

/* Type conversion operators renamed as functions.
 */
%rename(convert_VImage) vips::VIMask::operator vips::VImage;
%rename(convert_VImage) vips::VDMask::operator vips::VImage;

%rename(convert_VIMask) vips::VDMask::operator vips::VIMask;
%rename(convert_VDMask) vips::VIMask::operator vips::VDMask;

%include vips/VMask.h

%inline %{
  PyObject *nla_policy_array(int n_items)
  {
  	struct nla_policy *policies;
  	PyObject *listobj;
  	PyObject *polobj;
  	int i;

  	policies = calloc(n_items, sizeof(*policies));
  	listobj = PyList_New(n_items);
  	for (i = 0; i < n_items; i++) {
  		polobj = SWIG_NewPointerObj(SWIG_as_voidptr(&policies[i]),
  					    SWIGTYPE_p_nla_policy, 0 |  0 );
  		PyList_SetItem(listobj, i, polobj);
  	}
  	return listobj;
  }
%}

%extend CLASS {
  std::vector<TYPE *> *NAME() const {
    std::vector<TYPE *> *result = new std::vector<TYPE *>;
    result->reserve(LENGTH);

    TYPE *currentValue = $self->NAME;
    TYPE *valueLimit = $self->NAME + LENGTH;
    while (currentValue < valueLimit) {
      result->push_back(currentValue);
      ++currentValue;
    }

    return result;
  }
}
