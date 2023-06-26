module CooperativeDilemmas

using Distributions
using Roots
using Plots

greet() = print("Hello World!")

function poly_Bernstein(x,c)
	m = length(c) - 1
	return sum(pdf.(Binomial(m,x),0:m) .* c)
end

ffd(c) = (c-circshift(c,1))[2:length(c)] # first forward difference of array c

function total_payoffs(C,D)
    n = length(C)
    T = zeros(n+1)
    T[0+1] = n * D[0+1]
    for i = 1:(n-1)
        T[i+1] = i * C[i] + (n-i)*D[i+1]
    end
    T[n+1] = n * C[n]
    return T
end

private_gains(C,D) = C .- D

function external_gains(C,D)
    n = length(C)
    H = zeros(n)
    ΔC = ffd(C)
    ΔD = ffd(D)
    H[0+1] = (n-1)*ΔD[0+1]
    for k = 1:(n-2)
        H[k+1] = k*ΔC[k-1+1] + (n-1-k)*ΔD[k+1]
    end
    H[n-1+1] = (n-1)*ΔC[n-2+1]
    return H
end

social_gains(C,D) = ffd(total_payoffs(C,D))

function find_social_optimum(C,D)
    n = length(C)
    T = total_payoffs(C,D)
    S = social_gains(C,D)
    w(x) = poly_Bernstein(x,T/n) # expected average payoff w(x)
    s(x) = poly_Bernstein(x,S) # social gain function s(x)
    candidate_social_optima = find_zeros(s,0.,1.) # find roots of s(x)
    if length(candidate_social_optima) > 0 # if s has at least one root
        mxval, mxindx = findmax(w.(candidate_social_optima)) # get root of s with maximum w
        if mxval > w(1) # if the max value is greater than C_{n-1}, the social optimum is totally mixed
            x̂ = candidate_social_optima[mxindx]
        else # otherwise the social optimum is x=1      
	        x̂ = 1
        end
    else # if s has no root, x=1 must be the social optimum
        x̂ = 1
    end
    return x̂
end

function initial_sign(A)
    return first(filter!(x->x≠0,sign.(A)))
end

function final_sign(A)
    return last(filter!(x->x≠0,sign.(A)))
end

function find_totally_mixed_ESSs(G)
    g(x) = poly_Bernstein(x,G) # private gain function g(x)
    candidate_ESSs = sort(find_zeros(g,eps(),1-eps()))
    IS = initial_sign(G)
    if IS < 0 # initial sign is negative
        ESSs = candidate_ESSs[2:2:end]
    else # initial sign is positive
        ESSs = candidate_ESSs[begin:2:end]
    end
end

function find_ESSs(G)
    ESSs = []
    if initial_sign(G) < 0
        push!(ESSs,0.)
    end 
    ESSs = [ESSs; find_totally_mixed_ESSs(G)]
    if final_sign(G) > 0
        push!(ESSs,1.)
    end
    return ESSs 
end

function is_C_cooperative(C,D)
    n = length(C)
    if C[end] > D[begin]
        ΔC = ffd(C)
        ΔD = ffd(D)
        if (sum(sign.(ΔC) .>= 0) == n-1) && (sum(sign.(ΔD) .>= 0) == n-1) # if C and D are increasing
            return true
        else
            return false
        end 
    else
        return false
    end
end

function is_C_underprovided(C,D)
    G = C .- D
    xs = find_ESSs(G)
    xh = find_social_optimum(C,D)
    if sum(xs .> xh) > 0
        return false
    else
        return true
    end
end

function plot_example_12(z)
    C = [0,1,1+z]
	D = [1,2,1]
	T = total_payoffs(C,D)
    #S = social_gains(C,D)
	w(x) = poly_Bernstein(x,T/3)
    x̂ = find_social_optimum(C,D)
    x = range(0, 1, length=100)
	y = w.(x)
    plot(x,y,xlabel="probability of playing C",ylabel="expected payoff",label="")
	scatter!([x̂],[w(x̂)],markersize=6, c=:blue, label="")
end

function PGG(b,c)
    n = length(b)-1
    C = b[2:(n+1)] .- c
    D = b[1:n]
    return(C,D)
end

function congestion_games(v,γ)
    n = length(v)
    C = γ * ones(n)
    D = reverse(v[1:end])
    return(C,D)
end

function CGG(v,γ) # club goods games
    n = length(v)
    C = v
    D = γ * ones(n)
    return(C,D)
end

function plot_game(C,D)
    n = length(C)
    k = collect(0:n-1)
    # define sequences
    T = total_payoffs(C,D) 
	G = private_gains(C,D)
	H = external_gains(C,D)
	S = social_gains(C,D)
    # define functions
    wC(x) = poly_Bernstein(x,C) 
	wD(x) = poly_Bernstein(x,D) 
	w(x) = poly_Bernstein(x,T/n) 	
	g(x) = poly_Bernstein(x,G)
	h(x) = poly_Bernstein(x,H)
	s(x) = poly_Bernstein(x,S)
    # x and y values
    x = range(0, 1, length=100)
    ywC = wC.(x)
	ywD = wD.(x)
	yw = w.(x)
    yg = g.(x)
	yh = h.(x)
	ys = s.(x)
    # get ESSs and social optimum
    xs = find_totally_mixed_ESSs(G)
    xh = find_social_optimum(C,D)
    # create plot
    pl = plot(layout=(1,2),size=(600,400))
    plot!(tickfontsize=10,legendfontsize=10)
    # subplot 1 (left panel)
	plot!(subplot=1,x,ywC,color=palette(:seaborn_colorblind)[1],linewidth=2,label="\$w_C(x)\$",xlabel="probability of cooperating, \$x\$",ylabel="payoff",legend=:bottomright)
	plot!(subplot=1,x,ywD,color=palette(:seaborn_colorblind)[4],linewidth=2,label="\$w_D(x)\$")
	plot!(subplot=1,x,yw,linewidth=2,color=palette(:seaborn_colorblind)[5],label="\$w(x)\$")
    if length(xs) == 0
        if xh == 1
            plot!(subplot=1,xticks=([0,1],["0","1"]))
            plot!(subplot=1,yticks=([0,1],["0","1"]))
        else
            plot!(subplot=1,xticks=([0,xh,1],["0","\$\\hat{x}\$","1"]))
            plot!(subplot=1,yticks=([0,w(xh),1],["0","\$w(\\hat{x})\$","1"]))
        end
    else    
        plot!(subplot=1,xticks=([0,xs[1],xh,1],["0","\$x^*\$","\$\\hat{x}\$","1"]))
	    plot!(subplot=1,yticks=([0,1,w(xs[1]),w(xh)],["0","1","\$w(x^{\\ast})\$","\$w(\\hat{x})\$"]))
    end
	axes2left = twiny(pl[1])
    plot!(subplot=1,axes2left,tickfontsize=10,legendfontsize=10)
	plot!(subplot=1,axes2left,xticks=(k,string.(k)),xlabel="number of \$\\mathcal{C}\$ co-players, \$k\$")
	plot!(subplot=1,axes2left,k,C,linewidth=2,linestyle=:dash,markershape=:circle,markersize=5,color=palette(:seaborn_colorblind)[1],label="\$C_k\$",legend=:right)
	plot!(subplot=1,axes2left,k,D,linewidth=2,linestyle=:dash,markershape=:rect,markersize=5,color=palette(:seaborn_colorblind)[4],label="\$D_k\$")
    if length(xs) == 1
        plot!(subplot=1,[xs[1],xs[1]],[minimum(vcat(ywC,ywD)),w(xs[1])],color="black",linestyle=:dash,label="")
        plot!(subplot=1,[0,xs[1]],[w(xs[1]),w(xs[1])],color="black",linestyle=:dash,label="")
    end
	plot!(subplot=1,[xh,xh],[minimum(vcat(ywC,ywD)),w(xh)],color="black",linestyle=:dash,label="")
	plot!(subplot=1,[0,xh],[w(xh),w(xh)],color="black",linestyle=:dash,label="")		
    # subplot 2 (right panel)
	plot!(subplot=2,x,yg,color=palette(:seaborn_colorblind)[3],linewidth=2,label="\$g(x)\$",xlabel="probability of cooperating, \$x\$",legend=:right)
	plot!(subplot=2,x,ys,color=palette(:seaborn_colorblind)[10],linewidth=2,label="\$s(x)\$")	
	plot!(subplot=2,x,yh,color=palette(:seaborn_colorblind)[2],linewidth=2,label="\$h(x)\$")
	plot!(subplot=2,[0,1],[0,0],color="black",linestyle=:dash,label="")
    if length(xs) == 0
        if xh == 1
            plot!(subplot=2,xticks=([0,1],["0","1"]))
        else
            plot!(subplot=2,xticks=([0,xh,1],["0","\$\\hat{x}\$","1"]))
        end
    else
	    plot!(subplot=2,xticks=([0,xs[1],xh,1],["0","\$x^*\$","\$\\hat{x}\$","1"]))
    end
	axes2right = twiny(pl[2])
    plot!(subplot=2,axes2right,tickfontsize=10,legendfontsize=10)
	plot!(subplot=2,axes2right,xticks=(k,string.(k)),xlabel="number of \$\\mathcal{C}\$ co-players, \$k\$")
	plot(subplot=2,xticks=(k,string.(k)),xlabel="number of \$\\mathcal{C}\$ co-players, \$k\$")
	plot!(subplot=2,axes2right,k,G,linewidth=2,linestyle=:dash,markershape=:utriangle,markersize=5,color=palette(:seaborn_colorblind)[3],label="\$G_k\$",legend=:topright)
	plot!(subplot=2,axes2right,k,S,linewidth=2,linestyle=:dash,markershape=:circle,markersize=5,color=palette(:seaborn_colorblind)[10],label="\$S_k\$")
	plot!(subplot=2,axes2right,k,H,linewidth=2,linestyle=:dash,markershape=:rect,markersize=5,color=palette(:seaborn_colorblind)[2],label="\$H_k\$")	
    return pl
end

end # module
