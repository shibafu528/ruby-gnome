/* -*- c-file-style: "ruby"; indent-tabs-mode: nil -*- */
/*
 *  Copyright (C) 2011  Ruby-GNOME2 Project Team
 *  Copyright (C) 2007  Vincent Isambart <vincent.isambart@gmail.com>
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 *  MA  02110-1301  USA
 */

#include "rbgoocanvas.h"

#define RG_TARGET_NAMESPACE cMatrix

static VALUE
rb_cairo_matrix_to_goo(VALUE self)
{
    GValue gval = {0,};
    VALUE result;

    g_value_init(&gval, GOO_TYPE_CAIRO_MATRIX);
    g_value_set_boxed(&gval, RVAL2CRMATRIX(self));

    result = rbgobj_gvalue_to_rvalue(&gval);
    g_value_unset(&gval);

    return result;
}

void
Init_goocairomatrix(void)
{
    VALUE RG_TARGET_NAMESPACE = rb_const_get(rb_const_get(rb_mKernel, rb_intern("Cairo")), rb_intern("Matrix"));

    rb_define_method(RG_TARGET_NAMESPACE, "to_goo", rb_cairo_matrix_to_goo, 0);
}

