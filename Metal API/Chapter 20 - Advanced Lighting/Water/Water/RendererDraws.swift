import MetalKit

extension Renderer {

  func renderHouse(renderEncoder: MTLRenderCommandEncoder) {
    renderEncoder.pushDebugGroup("house")
    renderEncoder.setRenderPipelineState(pipelineState)
    renderEncoder.setVertexBuffer(model.vertexBuffers[0].buffer,
                                  offset: 0, index: 0)
    uniforms.modelMatrix = modelTransform.matrix
    uniforms.normalMatrix = modelTransform.matrix.upperLeft()
    renderEncoder.setVertexBytes(&uniforms,
                                 length: MemoryLayout<Uniforms>.stride,
                                 index: Int(BufferIndexUniforms.rawValue))
    renderEncoder.setFragmentTexture(modelTexture, index: 0)
    for submesh in model.submeshes {
      renderEncoder.drawIndexedPrimitives(type: .triangle,
                                          indexCount: submesh.indexCount,
                                          indexType: submesh.indexType,
                                          indexBuffer: submesh.indexBuffer.buffer,
                                          indexBufferOffset: submesh.indexBuffer.offset)
    }
    renderEncoder.popDebugGroup()
  }

  func renderTerrain(renderEncoder: MTLRenderCommandEncoder) {
    renderEncoder.pushDebugGroup("terrain")
    renderEncoder.setCullMode(.none)
    renderEncoder.setRenderPipelineState(terrainPipelineState)

    renderEncoder.setFragmentTexture(terrainTexture, index: 0)
    renderEncoder.setVertexBuffer(terrain.vertexBuffers[0].buffer, offset: 0, index: 0)
    uniforms.modelMatrix = terrainTransform.matrix
    uniforms.normalMatrix = terrainTransform.matrix.upperLeft()
    renderEncoder.setVertexBytes(&uniforms,
                                 length: MemoryLayout<Uniforms>.stride,
                                 index: Int(BufferIndexUniforms.rawValue))
    renderEncoder.setFragmentTexture(underwaterTexture, index: 1)
    for submesh in terrain.submeshes {
      renderEncoder.drawIndexedPrimitives(type: .triangle,
                                          indexCount: submesh.indexCount,
                                          indexType: submesh.indexType,
                                          indexBuffer: submesh.indexBuffer.buffer,
                                          indexBufferOffset: submesh.indexBuffer.offset)
    }
    renderEncoder.popDebugGroup()
  }
  
  func renderSkybox(renderEncoder: MTLRenderCommandEncoder) {
    renderEncoder.pushDebugGroup("skybox")
    renderEncoder.setCullMode(.back)
    renderEncoder.setRenderPipelineState(skyboxPipelineState)
    renderEncoder.setVertexBuffer(skybox.vertexBuffers[0].buffer, offset: 0, index: 0)
    var newMatrix = uniforms.viewMatrix
    newMatrix.columns.3 = [0, 0, 0, 1]
    uniforms.skyboxViewMatrix = newMatrix
    uniforms.modelMatrix = skyboxTransform.matrix
    renderEncoder.setVertexBytes(&uniforms,
                                 length: MemoryLayout<Uniforms>.stride,
                                 index: Int(BufferIndexUniforms.rawValue))

    renderEncoder.setFragmentTexture(skyboxTexture, index: 0)
    let submesh = skybox.submeshes[0]
    renderEncoder.drawIndexedPrimitives(type: .triangle,
                                        indexCount: submesh.indexCount,
                                        indexType: submesh.indexType,
                                        indexBuffer: submesh.indexBuffer.buffer,
                                        indexBufferOffset: 0)
    renderEncoder.popDebugGroup()
  }
  
  func renderWater(renderEncoder: MTLRenderCommandEncoder) {
    renderEncoder.pushDebugGroup("water")
    renderEncoder.setRenderPipelineState(waterPipelineState)
    renderEncoder.setVertexBuffer(water.vertexBuffers[0].buffer, offset: 0, index: 0)
    uniforms.modelMatrix = waterTransform.matrix
    renderEncoder.setVertexBytes(&uniforms,
                                 length: MemoryLayout<Uniforms>.stride,
                                 index: Int(BufferIndexUniforms.rawValue))
    renderEncoder.setFragmentTexture(reflectionRenderPass.texture, index: 0)
    renderEncoder.setFragmentTexture(waterTexture, index: 2)
    renderEncoder.setFragmentBytes(&timer,
                                   length: MemoryLayout<Float>.size,
                                   index: 3)
    renderEncoder.setFragmentTexture(refractionRenderPass.texture, index: 1)
    renderEncoder.setFragmentTexture(refractionRenderPass.depthTexture,
                                     index: 4)
    
    for submesh in water.submeshes {
      renderEncoder.drawIndexedPrimitives(type: .triangle,
                                          indexCount: submesh.indexCount,
                                          indexType: submesh.indexType,
                                          indexBuffer: submesh.indexBuffer.buffer,
                                          indexBufferOffset: submesh.indexBuffer.offset)
    }
    renderEncoder.popDebugGroup()
  }
  
}
