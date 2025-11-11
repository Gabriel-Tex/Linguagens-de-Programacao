
# ================== ATIVIDADE PRÁTICA 01 ==================
    # CALCULAR OS NÓS DE UMA ÁRVORE EM LINGUAGEM FUNCIONAL (ELIXIR):

defmodule TreeDrawing do
    # fator de escala para espaçamento entre nós e níveis
  @escala 30

  # estrutura que representa um nó da árvore
  defmodule Tree do
    defstruct key: nil, val: nil, x: nil, y: nil, left: nil, right: nil
  end

 # função principal
  def depth_first(%Tree{} = arvore, nivel, limite_esquerdo) do
    case arvore do
      # caso de nó folha
      %Tree{key: chave, val: valor, left: nil, right: nil} ->
        coordenada_x = limite_esquerdo
        coordenada_y = @escala * nivel
        nova_arvore = %Tree{key: chave, val: valor, x: coordenada_x, y: coordenada_y, left: nil, right: nil}
        {nova_arvore, limite_esquerdo}

      # caso de nó com apenas filho esquerdo
      %Tree{key: chave, val: valor, left: filho_esquerdo, right: nil} ->
        {arvore_esquerda_atualizada, coordenada_x_raiz} = depth_first(filho_esquerdo, nivel + 1, limite_esquerdo)
        coordenada_x = coordenada_x_raiz
        coordenada_y = @escala * nivel
        nova_arvore = %Tree{key: chave, val: valor, x: coordenada_x, y: coordenada_y, left: arvore_esquerda_atualizada, right: nil}
        {nova_arvore, coordenada_x_raiz}

      # caso de nó com apenas filho direito
      %Tree{key: chave, val: valor, left: nil, right: filho_direito} ->
        {arvore_direita_atualizada, coordenada_x_raiz} = depth_first(filho_direito, nivel + 1, limite_esquerdo)
        coordenada_x = coordenada_x_raiz
        coordenada_y = @escala * nivel
        nova_arvore = %Tree{key: chave, val: valor, x: coordenada_x, y: coordenada_y, left: nil, right: arvore_direita_atualizada}
        {nova_arvore, coordenada_x_raiz}

      # caso de nó com dois filhos
      %Tree{key: chave, val: valor, left: filho_esquerdo, right: filho_direito} ->
        # processa recursivamente a subárvore esquerda
        {arvore_esquerda_atualizada, coordenada_x_esquerda, limite_direito_esquerdo} =
          depth_first_ambos(filho_esquerdo, nivel + 1, limite_esquerdo)

        # calcula o limite esquerdo para a subárvore direita e
# adiciona a escala para evitar sobreposição com a subárvore esquerda
        limite_esquerdo_direito = limite_direito_esquerdo + @escala

        # processa recursivamente a subárvore direita
        {arvore_direita_atualizada, coordenada_x_direita, limite_direito} =
          depth_first_ambos(filho_direito, nivel + 1, limite_esquerdo_direito)

        # calcula a coordenada x da raiz como ponto médio entre os filhos
        coordenada_x = div(coordenada_x_esquerda + coordenada_x_direita, 2)
        coordenada_y = @escala * nivel

        nova_arvore = %Tree{
          key: chave,
          val: valor,
          x: coordenada_x,
          y: coordenada_y,
          left: arvore_esquerda_atualizada,
          right: arvore_direita_atualizada
        }
        {nova_arvore, coordenada_x, limite_direito}
    end
  end

  # função auxiliar
  defp depth_first_ambos(%Tree{} = arvore, nivel, limite_esquerdo) do
    case depth_first(arvore, nivel, limite_esquerdo) do
      {arvore_atualizada, coordenada_x} ->
        {arvore_atualizada, coordenada_x, coordenada_x}  # para folhas e nós com um filho
      {arvore_atualizada, coordenada_x, limite_direito} ->
        {arvore_atualizada, coordenada_x, limite_direito}  # para nós com dois filhos
    end
  end

  # função que inicia o cálculo de coordenadad
  def calcular_coordenadas(arvore) do
    case depth_first(arvore, 0, 0) do
      {resultado, _} -> resultado
      {resultado, _, _} -> resultado
    end
  end

  # função que cria a árvore mostrada na seção 3.4.7
  def arvore do
    %Tree{
      key: :a, val: 111,
      left: %Tree{
        key: :b, val: 55,
        left: %Tree{
          key: :x, val: 100,
          left: %Tree{key: :z, val: 56, left: nil, right: nil},
          right: %Tree{key: :w, val: 23, left: nil, right: nil}
        },
        right: %Tree{
          key: :y, val: 105,
          left: nil,
          right: %Tree{key: :r, val: 77, left: nil, right: nil}
        }
      },
      right: %Tree{
        key: :c, val: 123,
        left: %Tree{
          key: :d, val: 119,
          left: %Tree{key: :g, val: 44, left: nil, right: nil},
          right: %Tree{
            key: :h, val: 50,
            left: %Tree{key: :i, val: 5, left: nil, right: nil},
            right: %Tree{key: :j, val: 6, left: nil, right: nil}
          }
        },
        right: %Tree{key: :e, val: 133, left: nil, right: nil}
      }
    }
  end

  # função que mostra apenas as coordenadas calculadas
  def mostrar_coordenadas do
    arvore = arvore()
    resultado = calcular_coordenadas(arvore)

    IO.puts "=== coordenadas dos nós: ==="
    imprimir_coordenadas(resultado)
    resultado
  end

  # função auxiliar que imprime as coordenadas de cada nó
  defp imprimir_coordenadas(nil), do: :ok
  defp imprimir_coordenadas(%Tree{key: chave, val: valor, x: coordenada_x, y: coordenada_y, left: esquerda, right: direita}) do
    IO.puts "Nó #{chave}(#{valor}): (x=#{coordenada_x}, y=#{coordenada_y})"
    imprimir_coordenadas(esquerda)
    imprimir_coordenadas(direita)
  end
end

TreeDrawing.mostrar_coordenadas()
