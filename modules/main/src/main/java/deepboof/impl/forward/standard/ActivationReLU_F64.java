/*
 * Copyright (c) 2016, Peter Abeles. All Rights Reserved.
 *
 * This file is part of DeepBoof
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package deepboof.impl.forward.standard;

import deepboof.forward.ActivationReLU;
import deepboof.tensors.Tensor_F64;

/**
 * Implementation of {@link ActivationReLU} for {@link Tensor_F64}.
 *
 * @author Peter Abeles
 */
public class ActivationReLU_F64 extends ElementWiseFunction<Tensor_F64>
		implements ActivationReLU<Tensor_F64> {

	@Override
	public void _forward(Tensor_F64 input, Tensor_F64 output) {
		_relu_forwards(input, output);
	}

	public static void _relu_forwards(Tensor_F64 input, Tensor_F64 output) {

		int length = input.length();

		int indexIn = input.startIndex;
		int indexOut = output.startIndex;

		for (int i = 0; i < length; i++) {
			double value = input.d[indexIn+i];
			if( value <= 0 )
				output.d[indexOut+i] = 0;
			else
				output.d[indexOut+i] = value;
		}
	}

	@Override
	public Class<Tensor_F64> getTensorType() {
		return Tensor_F64.class;
	}
}
