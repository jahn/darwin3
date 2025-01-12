.. include:: ../defs.hrst

.. _Viruses:

Viruses
^^^^^^^

Viruses are, like heterotrophic bacteria, considered a ‘plankton’ type in
darwin.  To make a plankton group viruses, set :varlink:`grp_virus` to 1 in
data.darwin, or set :varlink:`isvirus` to 1 for individual types in
data.traits.  Set the parameter :varlink:`infected`\ (jS,jV) to a value jI to
indicate that virus jV infects susceptible host jS to become infected host jI.
As a special case, jI can be equal to jS.  In this case, there is no explicit
infected type, see below.


With explicit infected type
'''''''''''''''''''''''''''

When jI :math:`\ne` jS, infected plankton are represented by a separate type,
typically with the same traits as the susceptible type except for a lower
growth rate.  Denoting the carbon biomass of the three ‘plankton’ types as
follows: susceptible, :math:`S`, infected, :math:`I`, and viruses, :math:`V`,
the tendencies due to interactions with viruses are

.. math::

   \frac{d S}{d t} &= \dots -\epsilon r_{\rm inf} Q^{\mathrm{c}}_S

   \frac{d I}{d t} &= \dots +\epsilon r_{\rm inf} (Q^{\mathrm{c}}_S + Q^{\mathrm{c}}_V) - \frac{1}{\tau} I

   \frac{d V}{d t} &= \dots - r_{\rm inf} Q^{\mathrm{c}}_V + \beta\frac{Q^{\mathrm{c}}_V}{Q^{\mathrm{c}}_I} \frac{1}{\tau} I

   \frac{d\op{DOC}}{d t} &= \dots + (1-\epsilon) r_{\rm inf} Q^{\mathrm{c}}_V
                                  + f_{\rm DOM}^{\rm burst}
                                    \left(1-\beta\frac{Q^{\mathrm{c}}_V}{Q^{\mathrm{c}}_I}\right) \frac{1}{\tau} I

   \frac{d\op{POC}}{d t} &= \dots + (1-f_{\rm DOM}^{\rm burst})
                                    \left(1-\beta\frac{Q^{\mathrm{c}}_V}{Q^{\mathrm{c}}_I}\right) \frac{1}{\tau} I

   \frac{d\op{DON}}{d t} &= \dots + (1-\epsilon) r_{\rm inf} Q^{\mathrm{c}}_V Q^{\mathrm{N}}_V
                                  + f_{\rm DOM}^{\rm burst}
                                    \left(Q^{\mathrm{N}}_I-\beta\frac{Q^{\mathrm{c}}_V Q^{\mathrm{N}}_V}{Q^{\mathrm{c}}_I}\right) \frac{1}{\tau} I

   \frac{d\op{PON}}{d t} &= \dots + (1-f_{\rm DOM}^{\rm burst})
                                    \left(Q^{\mathrm{N}}_I-\beta\frac{Q^{\mathrm{c}}_V Q^{\mathrm{N}}_V}{Q^{\mathrm{c}}_I}\right) \frac{1}{\tau} I

   & ...

where the individual infection rate in ind/m\ :sup:`3`/s is

.. math::

   r_{\rm inf} = \phi_S \frac{S}{Q^{\mathrm{c}}_S} \frac{V}{Q^{\mathrm{c}}_V}

With dynamic CDOM, a fraction :varlink:`fracCDOM` of the loss to DOM goes
to CDOM (with CDOM stoichiometry).


Without explicit infected type
''''''''''''''''''''''''''''''

When jI = jS, infection leads to immediate lysis and the tendencies become

.. math::

   \frac{d S}{d t} &= \dots -\epsilon r_{\rm inf} Q^{\mathrm{c}}_S

   \frac{d V}{d t} &= \dots + \beta\frac{Q^{\mathrm{c}}_V}{Q^{\mathrm{c}}_S} \epsilon r_{\rm inf} Q^{\mathrm{c}}_S
                    = \dots + \beta\epsilon r_{\rm inf} Q^{\mathrm{c}}_V

   \frac{d\op{DOC}}{d t} &= \dots + f_{\rm DOM}^{\rm burst}
                                    \left(1-\beta\frac{Q^{\mathrm{c}}_V}{Q^{\mathrm{c}}_S}\right)
                                    \epsilon r_{\rm inf} Q^{\mathrm{c}}_S

   \frac{d\op{POC}}{d t} &= \dots + (1-f_{\rm DOM}^{\rm burst})
                                    \left(1-\beta\frac{Q^{\mathrm{c}}_V}{Q^{\mathrm{c}}_I}\right)
                                    \epsilon r_{\rm inf} Q^{\mathrm{c}}_S

   \frac{d\op{DON}}{d t} &= \dots + f_{\rm DOM}^{\rm burst}
                                    \left(Q^{\mathrm{N}}_S-\beta\frac{Q^{\mathrm{c}}_V Q^{\mathrm{N}}_V}{Q^{\mathrm{c}}_S}\right)
                                    \epsilon r_{\rm inf} Q^{\mathrm{c}}_S

   \frac{d\op{PON}}{d t} &= \dots + (1-f_{\rm DOM}^{\rm burst})
                                    \left(Q^{\mathrm{N}}_S-\beta\frac{Q^{\mathrm{c}}_V Q^{\mathrm{N}}_V}{Q^{\mathrm{c}}_S}\right)
                                    \epsilon r_{\rm inf} Q^{\mathrm{c}}_S

   & ...

with :math:`r_{\rm inf}` form above.


Resistent plankton types
''''''''''''''''''''''''

Resistant plankton types are represented as susceptible types with a reduced
infection rate, :math:`\phi_R<\phi_S`.  The growth rate is usually also reduced,
:math:`\mu_R<\mu_S`, as a trade-off.  A fraction :math:`\gamma` of the growth
of either type may be transfered to the other to represent mutations:

.. math::

   \frac{d S}{d t} &= \dots -\gamma_{S R} \mu_S S + \gamma_{R S} \mu_R R
   \;,

   \frac{d R}{d t} &= \dots -\gamma_{R S} \mu_R R + \gamma_{S R} \mu_S S
   \;.


Parameters
''''''''''

.. csv-table:: Virus Parameters
   :delim: &
   :widths: 10,19,17,14,13,27
   :header: sym, param, trait param, default, units, comments
   :name: tab_phys_pkgs_darwin_vparams

                       & :varlink:`isvirus`\ (jV)                    & :varlink:`grp_virus`      & 0                     &                     & 1: type jV is a virus
                       & :varlink:`infected`\ (jS,jV)                & :varlink:`grp_infected`   & 0                     &                     & index of type resulting from infection of host jS with virus jV
   :math:`\phi_S`      & :varlink:`v_absorp`\ (jS,jV)                & :varlink:`a_v_absorp`     & 2.7×10\ :sup:`−19`    & m\ :sup:`3`\ /s/ind & = 0.27 μm\ :sup:`3`\ /ind/s = infection rate per number density
   :math:`\epsilon`    & :varlink:`v_abeff`\ (jS,jV)                 & :varlink:`a_v_abeff`      & 1                     & unitless            & absorption efficiency
   :math:`\tau`        & :varlink:`v_latent`\ (jS,jV)                & :varlink:`a_v_latent`     & 86400                 & s                   & latency period
   :math:`\beta`       & :varlink:`v_burst`\ (jS,jV)                 & :varlink:`a_v_burst`      & 20                    & virons              & burst size
   :math:`f_{\rm DOM}^{\rm burst}` & :varlink:`v_dompomfrac` (jS,jV) & :varlink:`a_v_dompomfrac` & 0.5     & unitless            & fraction of burst spoils to DOM
   :math:`\gamma_{jk}` & :varlink:`bioflux`\ (j,k)                   & :varlink:`a_bioflux`      & 0                     & unitless            & fraction of growth of type j transferred to k

For allometric trait generation, it is assumed that all plankton in the first
group are susceptible to all viruses in the second group (usually just one), so
the parameters apply to all types in a group.

This is different for growth transfer, :varlink:`bioflux`, which is assumed to
go by type within the groups: the first plankton in the source group transforms
into the first in the target group, etc.

The carbon content of an individual, :math:`Q^{\mathrm{c}}_j` =
:varlink:`qcarbon`\ (j), is described in :numref:`RespParams`.  A typical
value for a virus is 2.75×10\ :sup:`−15` mmol C/viron.  Quotas of infected
classes (carbon and other) are computed as a sum of those of the corresponding
susceptible and virus classes at model initialization.

