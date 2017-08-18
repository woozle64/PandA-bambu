/*
 *
 *                   _/_/_/    _/_/   _/    _/ _/_/_/    _/_/
 *                  _/   _/ _/    _/ _/_/  _/ _/   _/ _/    _/
 *                 _/_/_/  _/_/_/_/ _/  _/_/ _/   _/ _/_/_/_/
 *                _/      _/    _/ _/    _/ _/   _/ _/    _/
 *               _/      _/    _/ _/    _/ _/_/_/  _/    _/
 *
 *             ***********************************************
 *                              PandA Project
 *                     URL: http://panda.dei.polimi.it
 *                       Politecnico di Milano - DEIB
 *                        System Architectures Group
 *             ***********************************************
 *              Copyright (c) 2004-2017 Politecnico di Milano
 *
 *   This file is part of the PandA framework.
 *
 *   The PandA framework is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
*/
/**
 * @file sdc_code_motion.hpp
 * @brief Analysis step performing code motion speculation on the basis of sdc results.
 *
 * @author Marco Lattuada <marco.lattuada@polimi.it>
 *
*/
#ifndef SDC_CODE_MOTION_HPP
#define SDC_CODE_MOTION_HPP

///Superclass include
#include "function_frontend_flow_step.hpp"

///Utility include
#include "refcount.hpp"

/**
 * Speculation code motion step
 */
class SDCCodeMotion : public FunctionFrontendFlowStep
{
   private:
      /**
       * Return the set of analyses in relationship with this design step
       * @param relationship_type is the type of relationship to be considered
       */
      const std::unordered_set<std::pair<FrontendFlowStepType, FunctionRelationship> > ComputeFrontendRelationships(const DesignFlowStep::RelationshipType relationship_type) const;

   public:
      /**
       * Constructor.
       * @param AppM is the application manager
       * @param function_id is the node id of the function analyzed.
       * @param design_flow_manager is the design flow manager
       * @param parameters is the set of input parameters
       */
      SDCCodeMotion(const application_managerRef AppM, unsigned int function_id, const DesignFlowManagerConstRef design_flow_manager, const ParameterConstRef parameters);

      /**
       *  Destructor
       */
      ~SDCCodeMotion();

      /**
       * Performs the loops analysis
       */
      DesignFlowStep_Status InternalExec();

      /**
       * Initialize the step (i.e., like a constructor, but executed just before exec
       */
      virtual void Initialize();

      /**
       * Check if this step has actually to be executed
       * @return true if the step has to be executed
       */
      virtual bool HasToBeExecuted() const;

      /**
       * Compute the relationships of a step with other steps
       * @param dependencies is where relationships will be stored
       * @param relationship_type is the type of relationship to be computed
       */
      virtual void ComputeRelationships(DesignFlowStepSet & relationship, const DesignFlowStep::RelationshipType relationship_type);
};
#endif