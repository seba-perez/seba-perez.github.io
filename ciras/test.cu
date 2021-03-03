/* -------------------------------------------------------------------------
   Copyright (C) 2016-2017  Miguel Carcamo, Pablo Roman, Simon Casassus,
   Victor Moral, Fernando Rannou - miguel.carcamo@usach.cl
   This program includes Numerical Recipes (NR) based routines whose
   copyright is held by the NR authors. If NR routines are included,
   you are required to comply with the licensing set forth there.
   Part of the program also relies on an an ANSI C library for multi-stream
   random number generation from the related Prentice-Hall textbook
   Discrete-Event Simulation: A First Course by Steve Park and Larry Leemis,
   for more information please contact leemis@math.wm.edu
   Additionally, this program uses some NVIDIA routines whose copyright is held
   by NVIDIA end user license agreement (EULA).
   For the original parts of this code, the following license applies:
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   You should have received a copy of the GNU General Public License
   along with this program. If not, see <http://www.gnu.org/licenses/>.
 * -------------------------------------------------------------------------
 */

#include "frprmn.cuh"
#include "directioncosines.cuh"
#include "pillBox2D.cuh"
#include "gaussianSinc2D.cuh"
#include "gaussian2D.cuh"
#include "sinc2D.cuh"
#include "pswf_12D.cuh"
#include "fixedpoint.cuh"
#include <time.h>

int num_gpus;

inline bool IsAppBuiltAs64()
{
  #if defined(__x86_64) || defined(AMD64) || defined(_M_AMD64)
        return 1;
  #else
        return 0;
  #endif
}

/*
   This is a function that runs gpuvmem and calculates new regularization values according to the Belge et al. 2002 paper.
 */
std::vector<float> runGpuvmem(std::vector<float> args, Synthesizer *synthesizer)
{

        int cter = 0;
        std::vector<Fi*> fis = synthesizer->getOptimizator()->getObjectiveFuntion()->getFi();
        for(std::vector<Fi*>::iterator it = fis.begin(); it != fis.end(); it++)
        {
                if(cter)
                        (*it)->setPenalizationFactor(args[cter]);
                cter++;
        }

        synthesizer->clearRun();
        synthesizer->run();
        std::vector<float> fi_values = synthesizer->getOptimizator()->getObjectiveFuntion()->get_fi_values();
        std::vector<float> lambdas(fi_values.size(), 1.0f);

        for(int i=0; i < fi_values.size(); i++)
        {
                if(i>0)
                {
                        lambdas[i] = fi_values[0]/fi_values[i] * (logf(fi_values[i])/logf(fi_values[0]));
                        if(lambdas[i] < 0.0f)
                                lambdas[i] = 0.0f;
                }
        }

        return lambdas;
}

void optimizationOrder(Optimizator *optimizator, Image *image){
        optimizator->setImage(image);
        optimizator->setFlag(0);
        optimizator->optimize();
        /*optimizator->setFlag(1);
           optimizator->optimize();
           optimizator->setFlag(2);
           optimizator->optimize();
           optimizator->setFlag(3);
           optimizator->optimize();*/
}